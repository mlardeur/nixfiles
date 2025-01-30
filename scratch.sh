#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bc

# Function to convert an integer to its 32-bit binary representation
int_to_32bit_binary() {
    local binary=$(echo "obase=2; $1" | bc)
    printf "%032s" "$binary" | tr ' ' '0'
}

all_tags=$(((1 << 32) - 1))
scratch_tag=$((1 << 19)) # 20
all_but_scratch_tag=$(( ((1 << 32) - 1) ^ scratch_tag ))
sticky_tag=$((1 << 31))
all_but_sticky_tag=$(( $all_tags ^ $sticky_tag ))
all_but_misc_tags=$(( $all_tags ^ $scratch_tag ^ $sticky_tag ))

# Print tags\
echo -e "All: \t $all_tags \t $(int_to_32bit_binary $all_tags)"
echo -e "Scratch 20: \t $scratch_tag \t $(int_to_32bit_binary $scratch_tag)"
echo -e "All but Scratch: \t $all_but_scratch_tag \t $(int_to_32bit_binary $all_but_scratch_tag)"
echo -e "Sticky: \t $sticky_tag \t $(int_to_32bit_binary $sticky_tag)"
echo -e "All but Sticky: \t $all_but_sticky_tag \t $(int_to_32bit_binary $all_but_sticky_tag)"
echo -e "All but misc tags: \t $all_but_misc_tags \t $(int_to_32bit_binary $all_but_misc_tags)"

for i in $(seq 1 32)
do
    tags=$((1 << ($i - 1)))
    echo -e "$i \t $tags \t\t $(int_to_32bit_binary $tags) \t\t $(($sticky_tag + $tags)) \t\t $(int_to_32bit_binary $(($sticky_tag + $tags)))"
done


