grab_pixel() {
    pgrep -x slurp || grim -g "$(slurp -p -b '#00000000')" /tmp/pixel.png
}

convert_pixel_to_hex() {
    if [[ -w "/tmp/pixel.png" ]]; then
        magick /tmp/pixel.png -format '%pixel:p{0,0}' txt: | grep -E "#[a-fA-F0-9]{3,6}" -o
    fi
}

upscale_pixel() {
    if [[ -w "/tmp/pixel.png" ]]; then
        magick -size 64x64 /tmp/pixel.png /tmp/pixel_upscaled.png
    fi
}

notify() {
    notify-send "$1 copied to clipboard" -i /tmp/pixel_upscaled.png &> /dev/null
}

main() {
    grab_pixel
    HEX=$(convert_pixel_to_hex)
    wl-copy ${HEX}
    upscale_pixel
    if [[ -e "/tmp/pixel.png" ]]; then
        notify ${HEX}
    fi
    if [[ -e "/tmp/pixel.png" ]]; then 
        rm /tmp/pixel.png
    fi
    if [[ -e "/tmp/pixel_upscaled.png" ]]; then 
        rm /tmp/pixel_upscaled.png
    fi
}

main
