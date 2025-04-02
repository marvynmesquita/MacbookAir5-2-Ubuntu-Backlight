#!/bin/bash
# keyboard_backlit_adjust.sh
#
# Este script ajusta o brilho do teclado (smc::kbd_backlight) de forma inversa
# ao brilho do monitor (acpi_video0) em tempo real, com transições suaves.
#
# Requisitos:
#   - brightnessctl deve estar configurado para os dispositivos "acpi_video0" e "smc::kbd_backlight".
#   - O script deve ser executado no ambiente do usuário.

#############################
# Configurações Gerais
#############################
MAIN_INTERVAL=1                # Intervalo para verificação (em segundos)
SCREEN_DEVICE="acpi_video0"
KEYBOARD_DEVICE="smc::kbd_backlight"

# Parâmetros para ajuste automático
MIN_KEYBOARD_BRIGHTNESS=20     # Brilho mínimo que o teclado terá
MAX_KEYBOARD_BRIGHTNESS=255    # Brilho máximo (100%)
TRANSITION_SLEEP=0.05          # Intervalo entre passos na transição suave (segundos)

###################################
# Função: Ajuste Automático do Teclado
###################################
auto_adjust() {
    current_screen=$(brightnessctl -d "$SCREEN_DEVICE" get)
    max_screen=$(brightnessctl -d "$SCREEN_DEVICE" max)
    
    # Calcula o brilho desejado para o teclado de forma inversa ao brilho do monitor.
    new_keyboard=$(( MAX_KEYBOARD_BRIGHTNESS - (current_screen * MAX_KEYBOARD_BRIGHTNESS / max_screen) ))
    if [ "$new_keyboard" -lt "$MIN_KEYBOARD_BRIGHTNESS" ]; then
        new_keyboard=$MIN_KEYBOARD_BRIGHTNESS
    fi
    
    gradual_keyboard_change "$new_keyboard"
    echo "$(date) - Monitor: ${current_screen}/${max_screen} | Teclado ajustado para: $new_keyboard"
}

####################################################
# Função: Transição Gradual para o Novo Valor de Brilho
####################################################
gradual_keyboard_change() {
    target=$1
    current=$(brightnessctl -d "$KEYBOARD_DEVICE" get)
    diff=$(( target - current ))
    if [ $diff -lt 0 ]; then
        diff=$(( -diff ))
    fi
    # Divide a diferença em 20 passos para uma transição suave.
    steps=20
    step=$(( diff / steps ))
    [ $step -eq 0 ] && step=1

    while true; do
        current=$(brightnessctl -d "$KEYBOARD_DEVICE" get)
        if [ "$current" -lt "$target" ]; then
            new_val=$(( current + step ))
            [ "$new_val" -gt "$target" ] && new_val=$target
        elif [ "$current" -gt "$target" ]; then
            new_val=$(( current - step ))
            [ "$new_val" -lt "$target" ] && new_val=$target
        else
            break
        fi
        brightnessctl -d "$KEYBOARD_DEVICE" set "$new_val"
        sleep "$TRANSITION_SLEEP"
        [ "$new_val" -eq "$target" ] && break
    done
}

####################
# Loop Principal
####################
while true; do
    auto_adjust
    sleep "$MAIN_INTERVAL"
done
