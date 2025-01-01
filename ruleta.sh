#!/bin/bash

# colores
RED='\033[31m'
GREEN='\033[0;32m'
YELLOW='\033[33m'
BLUE='\033[34m'
MAGENTA='\033[35m'
CYAN='\033[36m'
RESET='\033[0m'
BLACK='\033[30m'

# funcion ctrl c
ctrl_c(){
  echo -e "\n${RED}[!] Saliendo... ${RESET}"
  exit 1
}

#Ctrl+C
trap ctrl_c INT

# funcion para obtener el color segun el numero
get_color() {
  local num=$1
  if [ "$num" -eq 0 ]; then

    echo "verde"
  elif (( num % 2 == 0 )); then
    echo "negro"
  else
    echo "rojo"
  fi
}

saldo=1000 # saldo inicial del jugador

# simular ruleta
echo -e "     ¡BIENVENIDO A LA RULETA ${GREEN}SPIRAL v1.0${RESET}!"

while true; do
  echo 
  echo -e "${GREEN}=============================================${RESET}"
  echo -e "SALDO ACTUAL: ${GREEN}\$${saldo}${RESET}"
  echo -e "${GREEN}=============================================${RESET}"
  echo -e "OPCIONES:"
  echo -e "1. Apostar a un numero ${GREEN}(0-36)${RESET}"
  echo -e "2. Apostar a un color (${BLACK}negro${RESET} o ${RED}rojo${RESET})" # ADD GREEN
  echo -e "3. Salir del juego"
  echo -e "${GREEN}=============================================${RESET}"
  echo -ne "${BLUE}selecciona tu apuesta (1/2/3):${RESET} "; read tipo_apuesta

  if [ "$tipo_apuesta" == "3" ]; then
    echo -e "gracias por jugar, tu saldo es ${GREEN}\$${saldo}${RESET}"
    break
  fi 

  while true; do
    echo -ne "${BLUE}¿cuanto desea apostar?${RESET} \$"; read apuesta

    if [[ "$apuesta" =~ ^[0-9]+$ ]]; then
      break
    else
      echo -e "${RED}cantidad invalida, asegurate de solo ingresar numeros.${RESET}"
    fi

    if (( apuesta > saldo )); then
      echo -e "${RED}no tienes suficiente saldo para esa apuesta.${RESET}"
      continue
    fi
  done


  # apuesta por numero
  if [ "$tipo_apuesta" == "1" ]; then
    while true; do
      echo -ne "${BLUE}elige un numero entre${RESET} ${GREEN}0 y 36${RESET}${BLUE}:${RESET} "; read numero_apostado
      if [[ "$numero_apostado" =~ ^[0-9]+$ ]] && [[ "$numero_apostado" > 0 ]] && [[ "$numero_apostado" < 36 ]]; then
        break 
      elif (( "$numero_apostado" < 0 || "$numero_apostado" > 36 )); then
        echo -e "${RED}asegurate de ingresar una cantidad valida y solo ingresar numeros.${RESET}"
        continue
      fi
      break
    done
    echo -e "\n${GREEN}girando la ruleta...\n${RESET}"
    numero_ruleta=$(( RANDOM % 37))
    color_ruleta=$( get_color $numero_ruleta )

    if [[ "$color_ruleta" == "rojo" ]]; then
      COLOR_VAR=$RED
    elif [[ "$color_ruleta" == "negro" ]]; then
      COLOR_VAR=$BLACK
    else
      COLOR_VAR=$GREEN
    fi

    echo -e "${BLUE}El numero de la ruleta es:${RESET} $numero_ruleta (${COLOR_VAR}$color_ruleta${RESET})"
    
    if [[ $numero_ruleta == $numero_apostado ]]; then
      ganancia=$(( apuesta * 35))
      saldo=$(( ganancia + saldo))
      echo -e "${GREEN}has ganado \$${ganancia}!${RESET}"
    else 
      saldo=$(( saldo - apuesta))
      echo -e "${RED}has perdido \$${apuesta}!${RESET}"
    fi

  # apuesta por color
  elif [[ "$tipo_apuesta" == "2" ]]; then
    echo -ne "${BLUE}elige un color (${RESET}${BLACK}negro${RESET}${BLUE}/${RESET}${RED}rojo${RESET}${BLUE}):${RESET} "; read color_apostado
    color_apostado=$(echo "$color_apostado" | tr '[:upper:]' '[:lower:]') #convertir a minusculas
    if (( "$color_apostado" != "rojo" && "$color_apostado" != "negro" )); then
      echo -e "${RED}color invalido, go again.${RESET}"
      continue
    fi
    echo -e "\n${GREEN}girando la ruleta...\n${RESET}"
    numero_ruleta=$(( RANDOM % 37))
    color_ruleta=$(get_color $numero_ruleta)
    color_ruleta=$(echo "$color_ruleta" | tr '[:upper:]' '[:lower:]' ) #convertir a minusculas
    #echo -e "DEBUG: color_apostado='$color_apostado', color_ruleta='$color_ruleta'" 
    if [[ "$color_ruleta" == "rojo" ]]; then
      COLOR_VAR=$RED
    elif [[ "$color_ruleta" == "negro" ]]; then
      COLOR_VAR=$BLACK
    else
      COLOR_VAR=$GREEN
    fi

    echo -e "${BLUE}el numero de la ruleta es:${RESET} $numero_ruleta (${COLOR_VAR}$color_ruleta${RESET})"

    if [[ "$color_apostado" == "$color_ruleta" ]]; then
      ganancia=$(( apuesta * 2))
      saldo=$(( saldo + ganancia))
      echo -e "${GREEN}has ganado \$${ganancia}!${RESET}"
    else
      saldo=$(( saldo - apuesta))
      echo -e "${RED}has perdido \$${apuesta}!${RESET}"
    fi
  else
    echo -e "${RED}opcion invalida, go again.${RESET}"
  fi

  # verificar saldo
  if (( saldo <= 0 )); then
    echo -e "${RED}te has quedado sin saldo${RESET}, ${GREEN}gracias por jugar.${RESET}"
    break
  fi
done


# generar numero random
#number=$(( RANDOM % 37 ))
#color=$(get_color $number)

# mostrar el resultado
#echo "el numero es: $number"
#echo "el color es: $color"
