// river-status: print per-output tag state for River compositors.
//
// Speaks river-status-unstable-v1 over Wayland (no libwayland dispatch helpers
// beyond wayland-client). It talks to wl_output at version 4 to learn the
// output name, and to zriver_status_manager_v1 at version 3 so the layout
// events (version 4 only) never need to be handled.
//
// Output format: one tab-separated line per output per change:
//
//   <name>\t<focused>\t<view>\t<urgent>
//
// where the three masks are 32-bit tag bitfields (tag N = bit N-1). "view" is
// the union of every tagset, so it stays correct when users enable multiple
// views per output.
//
// Depends only on: wayland-client. Build with the Nix derivation in this
// directory (uses wayland-scanner to generate the protocol bindings).

#define _POSIX_C_SOURCE 200809L

#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <wayland-client.h>

#include "river-status-unstable-v1-client-protocol.h"

#define OUTPUT_VERSION 4 /* gives wl_output.name */
#define MANAGER_VERSION 3 /* focused/view/urgent tags, no layout events */

struct output_ctx {
    struct wl_output *wl_output;
    struct zriver_output_status_v1 *status;
    char *name;
    uint32_t focused;
    uint32_t view;
    uint32_t urgent;
    struct output_ctx *next;
};

static struct wl_display *display;
static struct zriver_status_manager_v1 *status_manager;
static struct wl_registry *registry;
static struct output_ctx *outputs;

static void print_output(struct output_ctx *o) {
    if (!o->name) return;
    printf("%s\t%u\t%u\t%u\n", o->name, o->focused, o->view, o->urgent);
    fflush(stdout);
}

static void global_remove(void *data, struct wl_registry *registry, uint32_t name) {
    (void)data; (void)registry; (void)name;
}

static void handle_output_name(void *data, struct wl_output *wl_output, const char *name) {
    struct output_ctx *o = data;
    (void)wl_output;
    free(o->name);
    o->name = strdup(name);
    print_output(o);
}

static void handle_output_geometry(void *data, struct wl_output *wl_output,
        int32_t x, int32_t y, int32_t width, int32_t height, int32_t subpixel,
        const char *make, const char *model, int32_t transform) {
    (void)data; (void)wl_output; (void)x; (void)y; (void)width; (void)height;
    (void)subpixel; (void)make; (void)model; (void)transform;
}

static void handle_output_mode(void *data, struct wl_output *wl_output,
        uint32_t flags, int32_t width, int32_t height, int32_t refresh) {
    (void)data; (void)wl_output; (void)flags; (void)width; (void)height; (void)refresh;
}

static void handle_output_done(void *data, struct wl_output *wl_output) {
    (void)data; (void)wl_output;
}

static void handle_output_scale(void *data, struct wl_output *wl_output, int32_t factor) {
    (void)data; (void)wl_output; (void)factor;
}

static void handle_output_description(void *data, struct wl_output *wl_output,
        const char *description) {
    (void)data; (void)wl_output; (void)description;
}

static const struct wl_output_listener output_listener = {
    .geometry = handle_output_geometry,
    .mode = handle_output_mode,
    .done = handle_output_done,
    .scale = handle_output_scale,
    .name = handle_output_name,
    .description = handle_output_description,
};

static void handle_focused_tags(void *data, struct zriver_output_status_v1 *status, uint32_t tags) {
    struct output_ctx *o = data;
    (void)status;
    o->focused = tags;
    print_output(o);
}

static void handle_view_tags(void *data, struct zriver_output_status_v1 *status,
        struct wl_array *tags) {
    struct output_ctx *o = data;
    (void)status;
    uint32_t union_mask = 0;
    const uint32_t *it;
    wl_array_for_each(it, tags) union_mask |= *it;
    o->view = union_mask;
    print_output(o);
}

static void handle_urgent_tags(void *data, struct zriver_output_status_v1 *status, uint32_t tags) {
    struct output_ctx *o = data;
    (void)status;
    o->urgent = tags;
    print_output(o);
}

static const struct zriver_output_status_v1_listener status_listener = {
    .focused_tags = handle_focused_tags,
    .view_tags = handle_view_tags,
    .urgent_tags = handle_urgent_tags,
};

static void attach_status(struct output_ctx *o) {
    if (o->status || !status_manager || !o->wl_output) return;
    o->status = zriver_status_manager_v1_get_river_output_status(status_manager, o->wl_output);
    zriver_output_status_v1_add_listener(o->status, &status_listener, o);
}

static void handle_global(void *data, struct wl_registry *registry, uint32_t name,
        const char *interface, uint32_t version) {
    (void)data;
    if (strcmp(interface, wl_output_interface.name) == 0) {
        struct output_ctx *o = calloc(1, sizeof(*o));
        if (!o) exit(EXIT_FAILURE);
        o->wl_output = wl_registry_bind(registry, name, &wl_output_interface,
                OUTPUT_VERSION < version ? OUTPUT_VERSION : version);
        wl_output_add_listener(o->wl_output, &output_listener, o);
        o->next = outputs;
        outputs = o;
        attach_status(o);
    } else if (strcmp(interface, zriver_status_manager_v1_interface.name) == 0) {
        uint32_t use = MANAGER_VERSION < version ? MANAGER_VERSION : version;
        status_manager = wl_registry_bind(registry, name, &zriver_status_manager_v1_interface, use);
        for (struct output_ctx *o = outputs; o; o = o->next) {
            attach_status(o);
        }
    }
}

int main(void) {
    setvbuf(stdout, NULL, _IOLBF, 0);

    display = wl_display_connect(NULL);
    if (!display) {
        fprintf(stderr, "river-status: could not connect to Wayland display\n");
        return 1;
    }

    registry = wl_display_get_registry(display);
    wl_registry_add_listener(registry, &(struct wl_registry_listener){
        .global = handle_global,
        .global_remove = global_remove,
    }, NULL);

    if (wl_display_roundtrip(display) == -1) {
        fprintf(stderr, "river-status: roundtrip failed\n");
        return 1;
    }
    if (!status_manager) {
        fprintf(stderr, "river-status: not running under a River compositor "
                "(no zriver_status_manager_v1 global)\n");
        return 1;
    }

    while (wl_display_dispatch(display) != -1) { }
    wl_display_disconnect(display);
    return 0;
}
