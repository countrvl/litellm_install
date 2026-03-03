#!/bin/bash

# --- Localization ---

# Default language
LANG_CODE="en"

# Function to set language based on locale or argument
set_language() {
    if [[ -n "$1" ]]; then
        LANG_CODE="$1"
    else
        # Detect system locale
        LOCALE=$(locale | grep LANG | cut -d= -f2 | cut -d. -f1 | tr '[:upper:]' '[:lower:]')
        if [[ "$LOCALE" == "ru_ru" || "$LOCALE" == "ru" ]]; then
            LANG_CODE="ru"
        fi
    fi
}

# Call set_language early to define messages
set_language "$1"

# English messages
declare -A EN_MESSAGES
EN_MESSAGES["welcome"]="Welcome to the LiteLLM & OpenClaw Installer!"
EN_MESSAGES["os_check"]="Checking OS compatibility..."
EN_MESSAGES["os_unsupported"]="Unsupported OS. This script only supports Debian/Ubuntu."
EN_MESSAGES["sudo_check"]="Checking for root privileges..."
EN_MESSAGES["sudo_required"]="This script must be run with sudo."
EN_MESSAGES["dependencies_install"]="Installing essential dependencies..."
EN_MESSAGES["dependencies_error"]="Failed to install dependencies. Please check your internet connection and try again."
EN_MESSAGES["port_prompt"]="Enter the port for LiteLLM Proxy (default: 4000): "
EN_MESSAGES["port_invalid"]="Invalid port. Please enter a number between 1024 and 65535."
EN_MESSAGES["port_in_use"]="Port %s is already in use. Please choose another port."
EN_MESSAGES["master_key_prompt"]="Enter a strong Master Key for LiteLLM (press Enter to auto-generate): "
EN_MESSAGES["master_key_generated"]="Master Key auto-generated: %s"
EN_MESSAGES["llm_selection_prompt"]="Select LLM providers to configure (use SPACE to select, ENTER to confirm):"
EN_MESSAGES["llm_none_selected"]="No LLM providers selected. LiteLLM will not be configured."
EN_MESSAGES["api_key_prompt"]="Enter API Key for %s: "
EN_MESSAGES["api_key_invalid"]="Invalid API Key for %s. Please check it and try again, or press Enter to skip."
EN_MESSAGES["api_key_skipped"]="API Key for %s skipped."
EN_MESSAGES["priority_prompt"]="Enter the priority order for selected LLMs (e.g., 1 2 3 for %s %s %s): "
EN_MESSAGES["priority_invalid"]="Invalid priority order. Please enter unique numbers for each selected LLM."
EN_MESSAGES["litellm_install"]="Installing LiteLLM..."
EN_MESSAGES["litellm_install_error"]="Failed to install LiteLLM. Please check your internet connection and try again."
EN_MESSAGES["config_generate"]="Generating LiteLLM configuration..."
EN_MESSAGES["systemd_setup"]="Setting up LiteLLM as a systemd service..."
EN_MESSAGES["systemd_start"]="Starting LiteLLM service..."
EN_MESSAGES["systemd_status"]="Checking LiteLLM service status..."
EN_MESSAGES["systemd_error"]="LiteLLM service failed to start. Check logs with 'journalctl -u litellm.service'."
EN_MESSAGES["litellm_ready"]="LiteLLM Proxy is running and accessible at http://localhost:%s."
EN_MESSAGES["openclaw_config_info"]="To connect OpenClaw to LiteLLM, use these settings:"
EN_MESSAGES["api_base"]="API Base: http://localhost:%s/openai/v1"
EN_MESSAGES["master_key"]="Master Key: %s"
EN_MESSAGES["openclaw_model"]="Model for OpenClaw: openclaw-brain"
EN_MESSAGES["openclaw_install_prompt"]="Do you want to launch the official OpenClaw installer? (y/n): "
EN_MESSAGES["openclaw_install_start"]="Transferring control to the OpenClaw installer..."
EN_MESSAGES["openclaw_install_skipped"]="OpenClaw installation skipped. You can run it manually later."
EN_MESSAGES["uninstall_confirm"]="Are you sure you want to uninstall LiteLLM and remove all related files? (y/n): "
EN_MESSAGES["uninstall_aborted"]="Uninstallation aborted."
EN_MESSAGES["uninstall_complete"]="LiteLLM uninstallation complete."
EN_MESSAGES["update_start"]="Updating LiteLLM..."
EN_MESSAGES["update_complete"]="LiteLLM update complete."
EN_MESSAGES["script_complete"]="Script finished."
EN_MESSAGES["error_occurred"]="An error occurred. Exiting."
EN_MESSAGES["cleanup_message"]="Cleaning up temporary files..."
EN_MESSAGES["lang_flag_invalid"]="Invalid language code. Use 'en' or 'ru'."

# Russian messages
declare -A RU_MESSAGES
RU_MESSAGES["welcome"]="Добро пожаловать в установщик LiteLLM и OpenClaw!"
RU_MESSAGES["os_check"]="Проверка совместимости ОС..."
RU_MESSAGES["os_unsupported"]="Неподдерживаемая ОС. Этот скрипт работает только на Debian/Ubuntu."
RU_MESSAGES["sudo_check"]="Проверка прав суперпользователя..."
RU_MESSAGES["sudo_required"]="Этот скрипт должен быть запущен с sudo."
RU_MESSAGES["dependencies_install"]="Установка необходимых зависимостей..."
RU_MESSAGES["dependencies_error"]="Не удалось установить зависимости. Проверьте подключение к интернету и попробуйте снова."
RU_MESSAGES["port_prompt"]="Введите порт для LiteLLM Proxy (по умолчанию: 4000): "
RU_MESSAGES["port_invalid"]="Неверный порт. Введите число от 1024 до 65535."
RU_MESSAGES["port_in_use"]="Порт %s уже занят. Выберите другой порт."
RU_MESSAGES["master_key_prompt"]="Введите надежный Master Key для LiteLLM (нажмите Enter для автогенерации): "
RU_MESSAGES["master_key_generated"]="Master Key сгенерирован автоматически: %s"
RU_MESSAGES["llm_selection_prompt"]="Выберите провайдеров LLM для настройки (используйте SPACE для выбора, ENTER для подтверждения):"
RU_MESSAGES["llm_none_selected"]="Провайдеры LLM не выбраны. LiteLLM не будет настроен."
RU_MESSAGES["api_key_prompt"]="Введите API Key для %s: "
RU_MESSAGES["api_key_invalid"]="Неверный API Key для %s. Проверьте его и попробуйте снова, или нажмите Enter, чтобы пропустить."
RU_MESSAGES["api_key_skipped"]="API Key для %s пропущен."
RU_MESSAGES["priority_prompt"]="Введите порядок приоритета для выбранных LLM (например, 1 2 3 для %s %s %s): "
RU_MESSAGES["priority_invalid"]="Неверный порядок приоритета. Введите уникальные номера для каждой выбранной LLM."
RU_MESSAGES["litellm_install"]="Установка LiteLLM..."
RU_MESSAGES["litellm_install_error"]="Не удалось установить LiteLLM. Проверьте подключение к интернету и попробуйте снова."
RU_MESSAGES["config_generate"]="Генерация конфигурации LiteLLM..."
RU_MESSAGES["systemd_setup"]="Настройка LiteLLM как системного сервиса..."
RU_MESSAGES["systemd_start"]="Запуск сервиса LiteLLM..."
RU_MESSAGES["systemd_status"]="Проверка статуса сервиса LiteLLM..."
RU_MESSAGES["systemd_error"]="Сервис LiteLLM не запустился. Проверьте логи командой 'journalctl -u litellm.service'."
RU_MESSAGES["litellm_ready"]="LiteLLM Proxy запущен и доступен по адресу http://localhost:%s."
RU_MESSAGES["openclaw_config_info"]="Для подключения OpenClaw к LiteLLM используйте следующие настройки:"
RU_MESSAGES["api_base"]="API Base: http://localhost:%s/openai/v1"
RU_MESSAGES["master_key"]="Master Key: %s"
RU_MESSAGES["openclaw_model"]="Модель для OpenClaw: openclaw-brain"
RU_MESSAGES["openclaw_install_prompt"]="Хотите запустить официальный инсталлятор OpenClaw? (y/n): "
RU_MESSAGES["openclaw_install_start"]="Передаю управление инсталлятору OpenClaw..."
RU_MESSAGES["openclaw_install_skipped"]="Установка OpenClaw пропущена. Вы можете запустить её позже вручную."
RU_MESSAGES["uninstall_confirm"]="Вы уверены, что хотите удалить LiteLLM и все связанные файлы? (y/n): "
RU_MESSAGES["uninstall_aborted"]="Удаление отменено."
RU_MESSAGES["uninstall_complete"]="Удаление LiteLLM завершено."
RU_MESSAGES["update_start"]="Обновление LiteLLM..."
RU_MESSAGES["update_complete"]="Обновление LiteLLM завершено."
RU_MESSAGES["script_complete"]="Скрипт завершен."
RU_MESSAGES["error_occurred"]="Произошла ошибка. Выход."
RU_MESSAGES["cleanup_message"]="Очистка временных файлов..."
RU_MESSAGES["lang_flag_invalid"]="Неверный код языка. Используйте 'en' или 'ru'."

# Function to get translated message
msg() {
    local key="$1"
    shift
    if [[ "$LANG_CODE" == "ru" ]]; then
        printf "${RU_MESSAGES[\"$key\"]}" "$@"
    else
        printf "${EN_MESSAGES[\"$key\"]}" "$@"
    fi
}

# Parse command line arguments for language
for arg in "$@"; do
    case $arg in
        --lang=*) # Check for --lang=en or --lang=ru
            LANG_ARG="${arg#*=}"
            if [[ "$LANG_ARG" == "en" || "$LANG_ARG" == "ru" ]]; then
                set_language "$LANG_ARG"
            else
                error_exit "$(msg lang_flag_invalid)"
            fi
            shift # Remove argument from processing
            ;;
    esac
done

# If language not set by flag, detect from locale
if [[ -z "$LANG_ARG" ]]; then
    set_language
fi

# --- Logging and Messaging Functions ---
log_file="/var/log/litellm_installer.log"

info_msg() {
    echo -e "\e[32m[INFO]\e[0m $(date '+%Y-%m-%d %H:%M:%S') $1" | tee -a "$log_file"
}

warn_msg() {
    echo -e "\e[33m[WARN]\e[0m $(date '+%Y-%m-%d %H:%M:%S') $1" | tee -a "$log_file"
}

error_msg() {
    echo -e "\e[31m[ERROR]\e[0m $(date '+%Y-%m-%d %H:%M:%S') $1" | tee -a "$log_file"
}

error_exit() {
    error_msg "$1"
    cleanup
    exit 1
}

cleanup() {
    info_msg "$(msg cleanup_message)"
    rm -rf "$TEMP_DIR"
}

trap error_exit ERR INT TERM

# --- Variables ---
INSTALL_DIR="/opt/litellm"
VENV_DIR="$INSTALL_DIR/venv"
CONFIG_DIR="$INSTALL_DIR/config"
CONFIG_FILE="$CONFIG_DIR/config.yaml"
SYSTEMD_SERVICE_FILE="/etc/systemd/system/litellm.service"
OPENCLAW_INSTALL_SCRIPT="https://raw.githubusercontent.com/openclaw/openclaw/main/install.sh"

# Default values
LITELLM_PORT=4000
LITELLM_MASTER_KEY=""

# API Endpoints for validation
OPENAI_VALIDATION_URL="https://api.openai.com/v1/models"
ANTHROPIC_VALIDATION_URL="https://api.anthropic.com/v1/models"
DEEPSEEK_VALIDATION_URL="https://api.deepseek.com/v1/models"
GIGACHAT_VALIDATION_URL="https://gigachat.sber.ru/api/v1/models"

# --- Helper Functions ---

# Function to check if a port is in use
is_port_in_use() {
    sudo ss -tuln | grep -q ":$1 "
}

# Function to generate a random string
generate_random_string() {
    head /dev/urandom | tr -dc A-Za-z0-9_ | head -c 32
}

# Function to make an API request for key validation
make_api_request() {
    local provider="$1"
    local api_key="$2"
    local url="$3"
    local headers=""
    local data=""

    case "$provider" in
        "openai")
            headers="Authorization: Bearer $api_key"
            ;;
        "anthropic")
            headers="x-api-key: $api_key"
            ;;
        "deepseek")
            headers="Authorization: Bearer $api_key"
            ;;
        "gigachat")
            # GigaChat validation is more complex, usually involves getting a token first
            # For simplicity, we'll just check if the endpoint is reachable
            # A more robust check would involve token exchange
            ;;
    esac

    if [[ -n "$headers" ]]; then
        curl -s -o /dev/null -w "%{http_code}" -H "$headers" "$url"
    else
        curl -s -o /dev/null -w "%{http_code}" "$url"
    fi
}

# Function to validate API Key
validate_api_key() {
    local provider_name="$1"
    local api_key="$2"
    local validation_url="$3"
    local http_code

    if [[ -z "$api_key" ]]; then
        return 1 # Empty key is invalid
    fi

    info_msg "$(msg api_key_prompt)" "$provider_name"
    read -p "" api_key

    if [[ -z "$api_key" ]]; then
        warn_msg "$(msg api_key_skipped)" "$provider_name"
        return 1
    fi

    info_msg "Validating API Key for $provider_name..."
    http_code=$(make_api_request "$provider_name" "$api_key" "$validation_url")

    if [[ "$http_code" == "200" || "$http_code" == "401" || "$http_code" == "403" ]]; then
        # 200 OK, 401 Unauthorized (key is valid but lacks permissions), 403 Forbidden (similar to 401)
        # For GigaChat, a 200 from /models endpoint is a good sign.
        # For others, 401/403 often means the key format is correct but permissions are off, which is still a valid key format.
        return 0
    else
        error_msg "$(msg api_key_invalid)" "$provider_name"
        return 1
    fi
}

# --- Main Installation Logic ---

# Check for --update or --uninstall flags
for arg in "$@"; do
    case $arg in
        --update)
            info_msg "$(msg update_start)"
            if [[ -d "$VENV_DIR" ]]; then
                source "$VENV_DIR/bin/activate"
                pip install --upgrade "litellm[proxy]"
                deactivate
                sudo systemctl restart litellm.service
                info_msg "$(msg update_complete)"
            else
                error_msg "LiteLLM is not installed in $INSTALL_DIR. Please run the installer first."
            fi
            cleanup
            exit 0
            ;;
        --uninstall)
            read -p "$(msg uninstall_confirm)" confirm_uninstall
            if [[ "$confirm_uninstall" =~ ^[Yy]$ ]]; then
                info_msg "$(msg uninstall_complete)"
                sudo systemctl stop litellm.service || true
                sudo systemctl disable litellm.service || true
                sudo rm -f "$SYSTEMD_SERVICE_FILE"
                sudo systemctl daemon-reload
                sudo rm -rf "$INSTALL_DIR"
                info_msg "$(msg uninstall_complete)"
            else
                info_msg "$(msg uninstall_aborted)"
            fi
            cleanup
            exit 0
            ;;
    esac
done

info_msg "$(msg welcome)"

# 1. OS Check
info_msg "$(msg os_check)"
if ! grep -qE "(ubuntu|debian)" /etc/os-release; then
    error_exit "$(msg os_unsupported)"
fi

# 2. Sudo Check
info_msg "$(msg sudo_check)"
if [[ "$EUID" -ne 0 ]]; then
    error_exit "$(msg sudo_required)"
fi

# 3. Install Dependencies
info_msg "$(msg dependencies_install)"
sudo apt update -y || error_exit "$(msg dependencies_error)"
sudo apt install -y python3-venv git curl jq || error_exit "$(msg dependencies_error)"

# 4. Prompt for LiteLLM Port
while true; do
    read -p "$(msg port_prompt)" input_port
    LITELLM_PORT=${input_port:-4000}

    if ! [[ "$LITELLM_PORT" =~ ^[0-9]+$ ]] || (( LITELLM_PORT < 1024 || LITELLM_PORT > 65535 )); then
        error_msg "$(msg port_invalid)"
    elif is_port_in_use "$LITELLM_PORT"; then
        error_msg "$(msg port_in_use)" "$LITELLM_PORT"
    else
        break
    fi
done

# 5. Prompt for LiteLLM Master Key
read -p "$(msg master_key_prompt)" LITELLM_MASTER_KEY
if [[ -z "$LITELLM_MASTER_KEY" ]]; then
    LITELLM_MASTER_KEY=$(generate_random_string)
    info_msg "$(msg master_key_generated)" "$LITELLM_MASTER_KEY"
fi

# 6. Select LLM Providers
info_msg "$(msg llm_selection_prompt)"
LLM_OPTIONS=("GigaChat" "OpenAI" "Anthropic" "DeepSeek")
SELECTED_LLMS=()

select_llms() {
    local i=0 num_options=${#LLM_OPTIONS[@]}
    local selected_indices=()

    while true; do
        clear
        echo "$(msg llm_selection_prompt)"
        for j in "${!LLM_OPTIONS[@]}"; do
            if [[ " ${selected_indices[@]} " =~ " ${j} " ]]; then
                echo -e "\e[32m[x]\e[0m ${LLM_OPTIONS[$j]}"
            else
                echo -e "\e[31m[ ]\e[0m ${LLM_OPTIONS[$j]}"
            fi
        done
        echo -e "\nUse SPACE to toggle, ENTER to confirm."

        read -s -n 1 key
        case "$key" in
            " ") # Spacebar
                if [[ " ${selected_indices[@]} " =~ " ${i} " ]]; then
                    selected_indices=( "${selected_indices[@]/$i}" )
                else
                    selected_indices+=( "$i" )
                fi
                ;;
            "") # Enter
                break
                ;;
            *) # Other keys
                ;;
        esac
    done

    for idx in "${selected_indices[@]}"; do
        SELECTED_LLMS+=( "${LLM_OPTIONS[$idx]}" )
    done
}

select_llms

if [[ ${#SELECTED_LLMS[@]} -eq 0 ]]; then
    warn_msg "$(msg llm_none_selected)"
else
    # 7. Collect API Keys and Validate
    declare -A LLM_API_KEYS
    declare -A LLM_MODELS
    LLM_MODELS["GigaChat"]="gigachat/GigaChat"
    LLM_MODELS["OpenAI"]="openai/gpt-5-nano"
    LLM_MODELS["Anthropic"]="anthropic/claude-haiku-4-5"
    LLM_MODELS["DeepSeek"]="deepseek/deepseek-chat"

    for llm in "${SELECTED_LLMS[@]}"; do
        local api_key_var_name="${llm^^}_API_KEY"
        local validation_url=""
        case "$llm" in
            "GigaChat") validation_url="$GIGACHAT_VALIDATION_URL" ;;
            "OpenAI") validation_url="$OPENAI_VALIDATION_URL" ;;
            "Anthropic") validation_url="$ANTHROPIC_VALIDATION_URL" ;;
            "DeepSeek") validation_url="$DEEPSEEK_VALIDATION_URL" ;;
        esac

        while true; do
            read -p "$(msg api_key_prompt)" "$llm"
            local current_key="${!llm}"
            if validate_api_key "$llm" "$current_key" "$validation_url"; then
                LLM_API_KEYS["$llm"]="$current_key"
                break
            else
                read -p "$(msg api_key_invalid)" "$llm"
                if [[ -z "${!llm}" ]]; then
                    warn_msg "$(msg api_key_skipped)" "$llm"
                    break
                fi
            fi
        done
    done

    # 8. Determine LLM Priority
    if [[ ${#SELECTED_LLMS[@]} -gt 1 ]]; then
        info_msg "$(msg priority_prompt)" "${SELECTED_LLMS[@]}"
        read -p "" priority_order_input
        IFS=' ' read -r -a PRIORITY_ORDER <<< "$priority_order_input"

        if [[ ${#PRIORITY_ORDER[@]} -ne ${#SELECTED_LLMS[@]} ]]; then
            error_exit "$(msg priority_invalid)"
        fi

        # Reorder SELECTED_LLMS based on priority
        declare -A temp_llms
        for i in "${!PRIORITY_ORDER[@]}"; do
            temp_llms["${PRIORITY_ORDER[$i]}"]="${SELECTED_LLMS[$i]}"
        done
        SELECTED_LLMS=()
        for i in $(seq 1 ${#LLM_OPTIONS[@]}); do
            if [[ -n "${temp_llms[$i]}" ]]; then
                SELECTED_LLMS+=( "${temp_llms[$i]}" )
            fi
        done
    fi

    # 9. Install LiteLLM
    info_msg "$(msg litellm_install)"
    mkdir -p "$INSTALL_DIR"
    python3 -m venv "$VENV_DIR"
    source "$VENV_DIR/bin/activate"
    pip install --upgrade "litellm[proxy]"
    deactivate

    # 10. Generate LiteLLM Config
    info_msg "$(msg config_generate)"
    mkdir -p "$CONFIG_DIR"
    cat > "$CONFIG_FILE" << EOF
model_list:
$(for llm in "${SELECTED_LLMS[@]}"; do
    echo "  - model_name: $(echo "$llm" | tr '[:upper:]' '[:lower:]')-lite"
    echo "    litellm_params:"
    echo "      model: ${LLM_MODELS[$llm]}"
    if [[ "$llm" == "GigaChat" ]]; then
        echo "      ssl_verify: False"
    fi
    echo "      api_key: \"os.environ/${llm^^}_API_KEY\""
done)

litellm_settings:
  master_key: "$LITELLM_MASTER_KEY"

router_settings:
  routing_strategy: "priority"
  model_group_alias:
    - model_group: "openclaw-brain"
      models: [$(for llm in "${SELECTED_LLMS[@]}"; do echo -n "\"$(echo "$llm" | tr '[:upper:]' '[:lower:]')-lite\" "; done | sed 's/ $//')]
EOF

    # 11. Setup Systemd Service
    info_msg "$(msg systemd_setup)"
    cat > "$SYSTEMD_SERVICE_FILE" << EOF
[Unit]
Description=LiteLLM Proxy Service
After=network.target

[Service]
User=root
Group=root
WorkingDirectory=$INSTALL_DIR
ExecStart=$VENV_DIR/bin/litellm --config $CONFIG_FILE --port $LITELLM_PORT
Restart=always
Environment="LITELLM_MASTER_KEY=$LITELLM_MASTER_KEY"
$(for llm in "${SELECTED_LLMS[@]}"; do
    echo "Environment=\"$(echo "$llm" | tr '[:upper:]' '[:lower:]')_API_KEY=${LLM_API_KEYS[$llm]}\"
done)

[Install]
WantedBy=multi-user.target
EOF

    sudo systemctl daemon-reload
    sudo systemctl enable litellm.service

    # 12. Start and Check Service
    info_msg "$(msg systemd_start)"
    sudo systemctl start litellm.service
    sleep 5 # Give it a moment to start
    info_msg "$(msg systemd_status)"
    if ! sudo systemctl is-active --quiet litellm.service; then
        error_exit "$(msg systemd_error)"
    fi

    info_msg "$(msg litellm_ready)" "$LITELLM_PORT"

    # 13. OpenClaw Integration Info
    info_msg "$(msg openclaw_config_info)"
    info_msg "$(msg api_base)" "$LITELLM_PORT"
    info_msg "$(msg master_key)" "$LITELLM_MASTER_KEY"
    info_msg "$(msg openclaw_model)"

    # 14. Optional OpenClaw Installation
    read -p "$(msg openclaw_install_prompt)" install_oc
    if [[ "$install_oc" =~ ^[Yy]$ ]]; then
        info_msg "$(msg openclaw_install_start)"
        exec curl -sSL ${OPENCLAW_INSTALL_SCRIPT} | sudo bash
    else
        info_msg "$(msg openclaw_install_skipped)"
    fi
fi

info_msg "$(msg script_complete)"
cleanup


# Скрипт для установки LiteLLM с поддержкой GigaChat, OpenAI, Anthropic
# и опциональной установки OpenClaw на Debian/Ubuntu.

# --- Цвета для вывода в консоль ---
RED=\033[0;31m
GREEN=\033[0;32m
YELLOW=\033[0;33m
BLUE=\033[0;34m
NC=\033[0m # No Color

# --- Локализация ---
declare -A STRINGS

# Default to English
LANG_CODE="en"

# Function to set language based on system locale or --lang flag
function set_language() {
    local requested_lang="$1"
    if [[ -n "$requested_lang" ]]; then
        LANG_CODE="$requested_lang"
    else
        # Detect system locale
        local system_lang=$(locale | grep LANG | cut -d= -f2 | cut -d. -f1 | cut -d_ -f1)
        if [[ "$system_lang" == "ru" ]]; then
            LANG_CODE="ru"
        fi
    fi

    # Load strings for the selected language
    case "$LANG_CODE" in
        "ru")
            # Russian strings
            STRINGS["script_description"]="Скрипт для установки LiteLLM с поддержкой GigaChat, OpenAI, Anthropic и DeepSeek, и опциональной установки OpenClaw на Debian/Ubuntu."
            STRINGS["cleanup_interrupted"]="\nУстановка прервана. Запускается очистка..."
            STRINGS["cleanup_manual_delete"]="Если установка была частичной, вы можете удалить директорию ${LITELLM_DIR} вручную."
            STRINGS["error_root_required"]="Этот скрипт должен быть запущен от имени root (используйте sudo)."
            STRINGS["success_root_check"]="Проверка прав root пройдена."
            STRINGS["error_os_detect"]="Не удалось определить операционную систему. Скрипт поддерживает только Debian/Ubuntu."
            STRINGS["os_detected"]="ОС $OS_NAME $VERSION_ID обнаружена и поддерживается."
            STRINGS["error_os_unsupported"]="Скрипт поддерживает только Debian и Ubuntu. Обнаружена: $OS_NAME"
            STRINGS["install_deps_msg"]="Обновление списка пакетов и установка зависимостей..."
            STRINGS["error_deps_install"]="Не удалось установить необходимые пакеты."
            STRINGS["success_deps_install"]="Все зависимости установлены."
            STRINGS["port_setup_header"]="--- Настройка порта LiteLLM ---"
            STRINGS["port_prompt"]="Введите порт для LiteLLM (по умолчанию 4000): "
            STRINGS["port_check_msg"]="Проверка доступности порта ${input_port} для LiteLLM..."
            STRINGS["port_occupied_warn"]="Порт ${input_port} уже занят. Пожалуйста, выберите другой порт."
            STRINGS["port_invalid_warn"]="Неверный формат порта. Порт должен быть числом от 1024 до 65535."
            STRINGS["port_available_success"]="Порт ${LITELLM_PORT} доступен и выбран."
            STRINGS["master_key_setup_header"]="--- Настройка LiteLLM ---"
            STRINGS["master_key_prompt"]="Введите мастер-ключ для LiteLLM (будет использоваться для доступа к прокси, нажмите Enter для автогенерации): "
            STRINGS["master_key_auto_gen_success"]="Мастер-ключ LiteLLM автоматически сгенерирован: ${LITELLM_MASTER_KEY}"
            STRINGS["master_key_set_success"]="Мастер-ключ LiteLLM установлен."
            STRINGS["llm_selection_header"]="--- Выбор языковых моделей (LLM) ---"
            STRINGS["llm_selection_prompt"]="Выберите LLM, которые вы хотите использовать (введите номера через пробел, например: 1 3):"
            STRINGS["llm_selection_error_none"]="Вы не выбрали ни одной LLM. Установка невозможна без выбора хотя бы одной модели."
            STRINGS["llm_selection_success"]="Выбраны LLM: ${SELECTED_LLMS[@]}"
            STRINGS["api_key_entry_header"]="--- Ввод и проверка API-ключей ---"
            STRINGS["gigachat_client_id_prompt"]="Введите Client ID для GigaChat: "
            STRINGS["gigachat_client_secret_prompt"]="Введите Client Secret для GigaChat: "
            STRINGS["gigachat_key_empty_warn"]="Client ID или Client Secret для GigaChat не введены. Пропускаем проверку."
            STRINGS["gigachat_key_check_msg"]="Проверка GigaChat API-ключа..."
            STRINGS["gigachat_key_invalid_warn"]="Не удалось получить токен GigaChat. Проверьте Client ID и Client Secret. Ответ: ${auth_response_raw}"
            STRINGS["gigachat_key_api_error_warn"]="GigaChat API-ключ невалиден или недоступен (HTTP статус: ${http_code})."
            STRINGS["gigachat_key_valid_success"]="GigaChat API-ключ валиден."
            STRINGS["openai_key_prompt"]="Введите API-ключ для OpenAI (начинается с sk-): "
            STRINGS["openai_key_empty_warn"]="API-ключ для OpenAI не введен. Пропускаем проверку."
            STRINGS["openai_key_check_msg"]="Проверка OpenAI API-ключа..."
            STRINGS["openai_key_invalid_warn"]="OpenAI API-ключ невалиден (HTTP статус: 401 Unauthorized)."
            STRINGS["openai_key_api_error_warn"]="OpenAI API-ключ невалиден или недоступен (HTTP статус: ${http_code})."
            STRINGS["openai_key_valid_success"]="OpenAI API-ключ валиден."
            STRINGS["anthropic_key_prompt"]="Введите API-ключ для Anthropic (начинается с sk-ant-): "
            STRINGS["anthropic_key_empty_warn"]="API-ключ для Anthropic не введен. Пропускаем проверку."
            STRINGS["anthropic_key_check_msg"]="Проверка Anthropic API-ключа..."
            STRINGS["anthropic_key_invalid_warn"]="Anthropic API-ключ невалиден (HTTP статус: 401 Unauthorized)."
            STRINGS["anthropic_key_api_error_warn"]="Anthropic API-ключ невалиден или недоступен (HTTP статус: ${http_code})."
            STRINGS["anthropic_key_valid_success"]="Anthropic API-ключ валиден."
            STRINGS["deepseek_key_prompt"]="Введите API-ключ для DeepSeek (начинается с sk-): "
            STRINGS["deepseek_key_empty_warn"]="API-ключ для DeepSeek не введен. Пропускаем проверку."
            STRINGS["deepseek_key_check_msg"]="Проверка DeepSeek API-ключа..."
            STRINGS["deepseek_key_invalid_warn"]="DeepSeek API-ключ невалиден (HTTP статус: 401 Unauthorized)."
            STRINGS["deepseek_key_api_error_warn"]="DeepSeek API-ключ невалиден или недоступен (HTTP статус: ${http_code})."
            STRINGS["deepseek_key_valid_success"]="DeepSeek API-ключ валиден."
            STRINGS["key_retry_prompt"]="Ключ невалиден. Повторить ввод? (y/n): "
            STRINGS["key_skip_warn"]="Проверка ключа пропущена. Возможны проблемы с работой LLM."
            STRINGS["priority_setup_header"]="--- Настройка приоритетов LLM ---"
            STRINGS["priority_prompt_first"]="Выберите основную LLM (будет использоваться первой):"
            STRINGS["priority_prompt_next"]="Выберите следующую LLM в цепочке (Enter для пропуска):"
            STRINGS["priority_error_duplicate"]="Эта LLM уже выбрана. Пожалуйста, выберите другую."
            STRINGS["priority_error_invalid"]="Неверный выбор. Пожалуйста, введите номер из списка."
            STRINGS["priority_success"]="Приоритет LLM установлен: ${PRIORITIZED_LLMS[@]}"
            STRINGS["venv_create_msg"]="Создание виртуального окружения Python..."
            STRINGS["error_venv_create"]="Не удалось создать виртуальное окружение."
            STRINGS["success_venv_create"]="Виртуальное окружение создано."
            STRINGS["litellm_install_msg"]="Установка LiteLLM в виртуальное окружение..."
            STRINGS["error_litellm_install"]="Не удалось установить LiteLLM."
            STRINGS["success_litellm_install"]="LiteLLM успешно установлен."
            STRINGS["config_create_msg"]="Создание конфигурационного файла LiteLLM..."
            STRINGS["error_config_create"]="Не удалось создать конфигурационный файл LiteLLM."
            STRINGS["success_config_create"]="Конфигурационный файл LiteLLM создан."
            STRINGS["service_create_msg"]="Создание systemd сервиса для LiteLLM..."
            STRINGS["error_service_create"]="Не удалось создать systemd сервис для LiteLLM."
            STRINGS["success_service_create"]="systemd сервис для LiteLLM создан."
            STRINGS["service_start_msg"]="Запуск LiteLLM сервиса..."
            STRINGS["error_service_start"]="Не удалось запустить LiteLLM сервис."
            STRINGS["success_service_start"]="LiteLLM сервис успешно запущен."
            STRINGS["litellm_ready_msg"]="LiteLLM Proxy готов к работе!"
            STRINGS["openclaw_config_header"]="--- Настройка OpenClaw ---"
            STRINGS["openclaw_api_base"]="API Base: http://localhost:${LITELLM_PORT}/openai/v1"
            STRINGS["openclaw_master_key"]="Мастер-ключ: ${LITELLM_MASTER_KEY}"
            STRINGS["openclaw_model_name"]="Модель для OpenClaw: openclaw-brain"
            STRINGS["openclaw_install_prompt"]="Хотите запустить официальный инсталлятор OpenClaw? (y/n): "
            STRINGS["openclaw_install_transfer"]="Передаю управление инсталлятору OpenClaw..."
            STRINGS["openclaw_install_skipped"]="Установка OpenClaw пропущена. Вы можете запустить её позже вручную."
            STRINGS["uninstall_confirm_prompt"]="Вы уверены, что хотите полностью удалить LiteLLM и все его компоненты? (y/n): "
            STRINGS["uninstall_aborted"]="Удаление отменено."
            STRINGS["uninstall_msg"]="Удаление LiteLLM..."
            STRINGS["uninstall_service_stop"]="Остановка LiteLLM сервиса..."
            STRINGS["uninstall_service_disable"]="Отключение LiteLLM сервиса..."
            STRINGS["uninstall_service_remove"]="Удаление LiteLLM systemd файла..."
            STRINGS["uninstall_dir_remove"]="Удаление директории LiteLLM..."
            STRINGS["uninstall_success"]="LiteLLM успешно удален."
            STRINGS["update_msg"]="Обновление LiteLLM..."
            STRINGS["update_success"]="LiteLLM успешно обновлен."
            STRINGS["update_error"]="Не удалось обновить LiteLLM."
            STRINGS["help_usage"]="Использование: $0 [--lang ru|en] [--update|--uninstall|--help]"
            STRINGS["help_update"]="  --update    Обновить LiteLLM до последней версии."
            STRINGS["help_uninstall"]="  --uninstall Удалить LiteLLM и все его компоненты."
            STRINGS["help_lang"]="  --lang      Установить язык интерфейса (ru или en). По умолчанию определяется по системной локали."
            STRINGS["help_help"]="  --help      Показать это сообщение помощи."
            STRINGS["error_unknown_option"]="Неизвестная опция: $1"
            STRINGS["error_invalid_lang"]="Неверный код языка. Поддерживаются 'ru' и 'en'."
            ;;
        *)
            # English strings (default)
            STRINGS["script_description"]="Script for installing LiteLLM with GigaChat, OpenAI, Anthropic, and DeepSeek support, and optional OpenClaw installation on Debian/Ubuntu."
            STRINGS["cleanup_interrupted"]="\nInstallation interrupted. Cleaning up..."
            STRINGS["cleanup_manual_delete"]="If the installation was partial, you can manually remove the ${LITELLM_DIR} directory."
            STRINGS["error_root_required"]="This script must be run as root (use sudo)."
            STRINGS["success_root_check"]="Root privileges check passed."
            STRINGS["error_os_detect"]="Could not detect operating system. This script only supports Debian/Ubuntu."
            STRINGS["os_detected"]="OS $OS_NAME $VERSION_ID detected and supported."
            STRINGS["error_os_unsupported"]="This script only supports Debian and Ubuntu. Detected: $OS_NAME"
            STRINGS["install_deps_msg"]="Updating package list and installing dependencies..."
            STRINGS["error_deps_install"]="Failed to install required packages."
            STRINGS["success_deps_install"]="All dependencies installed."
            STRINGS["port_setup_header"]="--- LiteLLM Port Configuration ---"
            STRINGS["port_prompt"]="Enter the port for LiteLLM (default 4000): "
            STRINGS["port_check_msg"]="Checking availability of port ${input_port} for LiteLLM..."
            STRINGS["port_occupied_warn"]="Port ${input_port} is already in use. Please choose another port."
            STRINGS["port_invalid_warn"]="Invalid port format. Port must be a number between 1024 and 65535."
            STRINGS["port_available_success"]="Port ${LITELLM_PORT} is available and selected."
            STRINGS["master_key_setup_header"]="--- LiteLLM Configuration ---"
            STRINGS["master_key_prompt"]="Enter the LiteLLM master key (used for proxy access, press Enter for auto-generation): "
            STRINGS["master_key_auto_gen_success"]="LiteLLM master key automatically generated: ${LITELLM_MASTER_KEY}"
            STRINGS["master_key_set_success"]="LiteLLM master key set."
            STRINGS["llm_selection_header"]="--- LLM Selection ---"
            STRINGS["llm_selection_prompt"]="Select the LLMs you want to use (enter numbers separated by space, e.g., 1 3):"
            STRINGS["llm_selection_error_none"]="You have not selected any LLM. Installation is not possible without selecting at least one model."
            STRINGS["llm_selection_success"]="Selected LLMs: ${SELECTED_LLMS[@]}"
            STRINGS["api_key_entry_header"]="--- API Key Entry and Validation ---"
            STRINGS["gigachat_client_id_prompt"]="Enter Client ID for GigaChat: "
            STRINGS["gigachat_client_secret_prompt"]="Enter Client Secret for GigaChat: "
            STRINGS["gigachat_key_empty_warn"]="GigaChat Client ID or Client Secret not entered. Skipping validation."
            STRINGS["gigachat_key_check_msg"]="Validating GigaChat API key..."
            STRINGS["gigachat_key_invalid_warn"]="Failed to get GigaChat token. Check Client ID and Client Secret. Response: ${auth_response_raw}"
            STRINGS["gigachat_key_api_error_warn"]="GigaChat API key is invalid or unavailable (HTTP status: ${http_code})."
            STRINGS["gigachat_key_valid_success"]="GigaChat API key is valid."
            STRINGS["openai_key_prompt"]="Enter API key for OpenAI (starts with sk-): "
            STRINGS["openai_key_empty_warn"]="OpenAI API key not entered. Skipping validation."
            STRINGS["openai_key_check_msg"]="Validating OpenAI API key..."
            STRINGS["openai_key_invalid_warn"]="OpenAI API key is invalid (HTTP status: 401 Unauthorized)."
            STRINGS["openai_key_api_error_warn"]="OpenAI API key is invalid or unavailable (HTTP status: ${http_code})."
            STRINGS["openai_key_valid_success"]="OpenAI API key is valid."
            STRINGS["anthropic_key_prompt"]="Enter API key for Anthropic (starts with sk-ant-): "
            STRINGS["anthropic_key_empty_warn"]="Anthropic API key not entered. Skipping validation."
            STRINGS["anthropic_key_check_msg"]="Validating Anthropic API key..."
            STRINGS["anthropic_key_invalid_warn"]="Anthropic API key is invalid (HTTP status: 401 Unauthorized)."
            STRINGS["anthropic_key_api_error_warn"]="Anthropic API key is invalid or unavailable (HTTP status: ${http_code})."
            STRINGS["anthropic_key_valid_success"]="Anthropic API key is valid."
            STRINGS["deepseek_key_prompt"]="Enter API key for DeepSeek (starts with sk-): "
            STRINGS["deepseek_key_empty_warn"]="DeepSeek API key not entered. Skipping validation."
            STRINGS["deepseek_key_check_msg"]="Validating DeepSeek API key..."
            STRINGS["deepseek_key_invalid_warn"]="DeepSeek API key is invalid (HTTP status: 401 Unauthorized)."
            STRINGS["deepseek_key_api_error_warn"]="DeepSeek API key is invalid or unavailable (HTTP status: ${http_code})."
            STRINGS["deepseek_key_valid_success"]="DeepSeek API key is valid."
            STRINGS["key_retry_prompt"]="Key is invalid. Retry input? (y/n): "
            STRINGS["key_skip_warn"]="Key validation skipped. LLM may not work correctly."
            STRINGS["priority_setup_header"]="--- LLM Priority Configuration ---"
            STRINGS["priority_prompt_first"]="Select the primary LLM (will be used first):"
            STRINGS["priority_prompt_next"]="Select the next LLM in the chain (Enter to skip):"
            STRINGS["priority_error_duplicate"]="This LLM is already selected. Please choose another one."
            STRINGS["priority_error_invalid"]="Invalid choice. Please enter a number from the list."
            STRINGS["priority_success"]="LLM priority set: ${PRIORITIZED_LLMS[@]}"
            STRINGS["venv_create_msg"]="Creating Python virtual environment..."
            STRINGS["error_venv_create"]="Failed to create virtual environment."
            STRINGS["success_venv_create"]="Virtual environment created."
            STRINGS["litellm_install_msg"]="Installing LiteLLM into virtual environment..."
            STRINGS["error_litellm_install"]="Failed to install LiteLLM."
            STRINGS["success_litellm_install"]="LiteLLM successfully installed."
            STRINGS["config_create_msg"]="Creating LiteLLM configuration file..."
            STRINGS["error_config_create"]="Failed to create LiteLLM configuration file."
            STRINGS["success_config_create"]="LiteLLM configuration file created."
            STRINGS["service_create_msg"]="Creating systemd service for LiteLLM..."
            STRINGS["error_service_create"]="Failed to create systemd service for LiteLLM."
            STRINGS["success_service_create"]="systemd service for LiteLLM created."
            STRINGS["service_start_msg"]="Starting LiteLLM service..."
            STRINGS["error_service_start"]="Failed to start LiteLLM service."
            STRINGS["success_service_start"]="LiteLLM service successfully started."
            STRINGS["litellm_ready_msg"]="LiteLLM Proxy is ready!"
            STRINGS["openclaw_config_header"]="--- OpenClaw Configuration ---"
            STRINGS["openclaw_api_base"]="API Base: http://localhost:${LITELLM_PORT}/openai/v1"
            STRINGS["openclaw_master_key"]="Master Key: ${LITELLM_MASTER_KEY}"
            STRINGS["openclaw_model_name"]="Model for OpenClaw: openclaw-brain"
            STRINGS["openclaw_install_prompt"]="Do you want to run the official OpenClaw installer? (y/n): "
            STRINGS["openclaw_install_transfer"]="Transferring control to OpenClaw installer..."
            STRINGS["openclaw_install_skipped"]="OpenClaw installation skipped. You can run it manually later."
            STRINGS["uninstall_confirm_prompt"]="Are you sure you want to completely remove LiteLLM and all its components? (y/n): "
            STRINGS["uninstall_aborted"]="Uninstallation aborted."
            STRINGS["uninstall_msg"]="Uninstalling LiteLLM..."
            STRINGS["uninstall_service_stop"]="Stopping LiteLLM service..."
            STRINGS["uninstall_service_disable"]="Disabling LiteLLM service..."
            STRINGS["uninstall_service_remove"]="Removing LiteLLM systemd file..."
            STRINGS["uninstall_dir_remove"]="Removing LiteLLM directory..."
            STRINGS["uninstall_success"]="LiteLLM successfully uninstalled."
            STRINGS["update_msg"]="Updating LiteLLM..."
            STRINGS["update_success"]="LiteLLM successfully updated."
            STRINGS["update_error"]="Failed to update LiteLLM."
            STRINGS["help_usage"]="Usage: $0 [--lang ru|en] [--update|--uninstall|--help]"
            STRINGS["help_update"]="  --update    Update LiteLLM to the latest version."
            STRINGS["help_uninstall"]="  --uninstall Remove LiteLLM and all its components."
            STRINGS["help_lang"]="  --lang      Set interface language (ru or en). Defaults to system locale."
            STRINGS["help_help"]="  --help      Show this help message."
            STRINGS["error_unknown_option"]="Unknown option: $1"
            STRINGS["error_invalid_lang"]="Invalid language code. Supported: 'ru' and 'en'."
            ;;
    esac
}

# Call set_language early to load strings
set_language

# --- Функции ---

# Функция для вывода сообщений об ошибках и завершения работы
function error_exit() {
    echo -e "${RED}ОШИБКА: ${1}${NC}" >&2
    exit 1
}

# Функция для вывода информационных сообщений
function info_msg() {
    echo -e "${BLUE}ИНФО: ${1}${NC}"
}

# Функция для вывода предупреждений
function warn_msg() {
    echo -e "${YELLOW}ПРЕДУПРЕЖДЕНИЕ: ${1}${NC}"
}

# Функция для вывода сообщений об успехе
function success_msg() {
    echo -e "${GREEN}УСПЕХ: ${1}${NC}"
}

# Функция для вывода сообщений об ошибках и завершения работы
function error_exit() {
    echo -e "${RED}${STRINGS[error_prefix]}: ${1}${NC}" >&2
    exit 1
}

# Функция для вывода информационных сообщений
function info_msg() {
    echo -e "${BLUE}${STRINGS[info_prefix]}: ${1}${NC}"
}

# Функция для вывода предупреждений
function warn_msg() {
    echo -e "${YELLOW}${STRINGS[warn_prefix]}: ${1}${NC}"
}

# Функция для вывода сообщений об успехе
function success_msg() {
    echo -e "${GREEN}${STRINGS[success_prefix]}: ${1}${NC}"
}

# --- Цвета для вывода в консоль ---
RED=\033[0;31m
GREEN=\033[0;32m
YELLOW=\033[0;33m
BLUE=\033[0;34m
NC=\033[0m # No Color

# --- Переменные ---
LITELLM_DIR="/opt/litellm"
LITELLM_CONFIG_PATH="${LITELLM_DIR}/config.yaml"
LITELLM_SERVICE_PATH="/etc/systemd/system/litellm.service"
LITELLM_PORT=4000 # Порт по умолчанию
OPENCLAW_INSTALL_SCRIPT="https://raw.githubusercontent.com/openclaw/openclaw/main/install.sh" # Placeholder, replace with actual if available

# --- Функции ---

# Функция для очистки при прерывании
function cleanup() {
    warn_msg "\nУстановка прервана. Запускается очистка..."
    # Здесь можно добавить команды для удаления временных файлов, если они есть
    info_msg "Если установка была частичной, вы можете удалить директорию ${LITELLM_DIR} вручную."
    exit 1
}

trap cleanup INT TERM

# Вспомогательная функция для выполнения HTTP-запросов
function make_api_request() {
    local url="$1"
    local headers="$2"
    local data="$3"
    local method="$4"
    local timeout="$5"

    local response=$(curl -s -o /dev/null -w "%{http_code}" -X "$method" -H "Content-Type: application/json" ${headers} "$url" -d "$data" --insecure --max-time ${timeout:-10})
    local http_code=$(echo "$response" | tail -n 1)
    echo "$http_code"
}

# Вспомогательная функция для выполнения HTTP-запросов с получением тела ответа
function make_api_request_with_body() {
    local url="$1"
    local headers="$2"
    local data="$3"
    local method="$4"
    local timeout="$5"

    local response_body=$(curl -s -X "$method" -H "Content-Type: application/json" ${headers} "$url" -d "$data" --insecure --max-time ${timeout:-10})
    local http_code=$(echo "$response_body" | head -n 1 | grep -oP "(?<=HTTP/\S+\s)\d+") # Attempt to extract HTTP code if present
    if [[ -z "$http_code" ]]; then
        # If no HTTP code in body, try to get it from header (less reliable for -s)
        http_code=$(curl -s -o /dev/null -w "%{http_code}" -X "$method" -H "Content-Type: application/json" ${headers} "$url" -d "$data" --insecure --max-time ${timeout:-10})
    fi

    echo "$http_code"
    echo "$response_body"
}

# Проверка GigaChat API Key
function validate_gigachat_key() {
    local client_id="$1"
    local client_secret="$2"

    info_msg "Проверка GigaChat API-ключа..."

    local auth_data="{\"client_id\": \"${client_id}\", \"client_secret\": \"${client_secret}\", \"scope\": \"GIGACHAT_API_PERS\"}"
    local auth_response_raw=$(curl -s -X POST -H "Content-Type: application/json" -H "Accept: application/json" -d "${auth_data}" https://ngw.devices.sberbank.ru:9443/api/v2/oauth --insecure --max-time 15)
    local access_token=$(echo "$auth_response_raw" | jq -r ".access_token" 2>/dev/null)

    if [[ -z "$access_token" || "$access_token" == "null" ]]; then
        warn_msg "Не удалось получить токен GigaChat. Проверьте Client ID и Client Secret. Ответ: ${auth_response_raw}"
        return 1
    fi

    local headers="Authorization: Bearer ${access_token}"
    local check_url="https://gigachat.devices.sberbank.ru/api/v1/models"
    local http_code=$(make_api_request "$check_url" "-H \"${headers}\"" "" "GET" 10)

    if [[ "$http_code" -eq 200 ]]; then
        success_msg "GigaChat API-ключ валиден."
        return 0
    else
        warn_msg "GigaChat API-ключ невалиден или недоступен (HTTP статус: ${http_code})."
        return 1
    fi
}

# Проверка OpenAI API Key
function validate_openai_key() {
    local api_key="$1"

    info_msg "Проверка OpenAI API-ключа..."

    local headers="Authorization: Bearer ${api_key}"
    local check_url="https://api.openai.com/v1/models"
    local http_code=$(make_api_request "$check_url" "-H \"${headers}\"" "" "GET" 10)

    if [[ "$http_code" -eq 200 ]]; then
        success_msg "OpenAI API-ключ валиден."
        return 0
    elif [[ "$http_code" -eq 401 ]]; then
        warn_msg "OpenAI API-ключ невалиден (HTTP статус: 401 Unauthorized)."
        return 1
    else
        warn_msg "OpenAI API-ключ невалиден или недоступен (HTTP статус: ${http_code})."
        return 1
    fi
}

# Проверка Anthropic API Key
function validate_deepseek_key() {
    local api_key="$1"

    info_msg "Проверка DeepSeek API-ключа..."

    local headers="Authorization: Bearer ${api_key}"
    local check_url="https://api.deepseek.com/v1/models"
    local http_code=$(make_api_request "$check_url" "-H \"${headers}\"" "" "GET" 10)

    if [[ "$http_code" -eq 200 ]]; then
        success_msg "DeepSeek API-ключ валиден."
        return 0
    elif [[ "$http_code" -eq 401 ]]; then
        warn_msg "DeepSeek API-ключ невалиден (HTTP статус: 401 Unauthorized)."
        return 1
    else
        warn_msg "DeepSeek API-ключ невалиден или недоступен (HTTP статус: ${http_code})."
        return 1
    fi
}

function validate_anthropic_key() {
    local api_key="$1"

    info_msg "Проверка Anthropic API-ключа..."

    local headers="x-api-key: ${api_key}"
    local check_url="https://api.anthropic.com/v1/models"
    local http_code=$(make_api_request "$check_url" "-H \"${headers}\"" "" "GET" 10)

    if [[ "$http_code" -eq 200 ]]; then
        success_msg "Anthropic API-ключ валиден."
        return 0
    elif [[ "$http_code" -eq 401 ]]; then
        warn_msg "Anthropic API-ключ невалиден (HTTP статус: 401 Unauthorized)."
        return 1
    else
        warn_msg "Anthropic API-ключ невалиден или недоступен (HTTP статус: ${http_code})."
        return 1
    fi
}

# Проверка прав root
function check_root() {
    if [[ $EUID -ne 0 ]]; then
        error_exit "Этот скрипт должен быть запущен от имени root (используйте sudo)."
    fi
    success_msg "Проверка прав root пройдена."
}

# Проверка ОС (Debian/Ubuntu)
function check_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS_NAME=$NAME
        OS_VERSION_ID=$VERSION_ID
    else
        error_exit "Не удалось определить операционную систему. Скрипт поддерживает только Debian/Ubuntu."
    fi

    if [[ "$OS_NAME" != "Ubuntu" && "$OS_NAME" != "Debian GNU/Linux" ]]; then
        error_exit "Скрипт поддерживает только Debian и Ubuntu. Обнаружена: $OS_NAME"
    fi
    success_msg "ОС $OS_NAME $VERSION_ID обнаружена и поддерживается."
}

# Установка необходимых пакетов
function install_dependencies() {
    info_msg "Обновление списка пакетов и установка зависимостей..."
    apt update || error_exit "Не удалось обновить список пакетов."
    apt install -y python3-venv python3-pip git curl jq openssl iproute2 || error_exit "Не удалось установить необходимые пакеты."
    success_msg "Все зависимости установлены."
}

# Запрос порта LiteLLM
function get_litellm_port() {
    echo -e "\n${BLUE}--- Настройка порта LiteLLM ---${NC}"
    while true; do
        read -p "Введите порт для LiteLLM (по умолчанию 4000): " input_port
        input_port=${input_port:-4000} # Если пусто, используем 4000

        if [[ "$input_port" =~ ^[0-9]+$ ]] && ((input_port >= 1024 && input_port <= 65535)); then
            info_msg "Проверка доступности порта ${input_port} для LiteLLM..."
            if ss -tuln | grep -q ":${input_port} "; then
                warn_msg "Порт ${input_port} уже занят. Пожалуйста, выберите другой порт."
            else
                LITELLM_PORT=$input_port
                success_msg "Порт ${LITELLM_PORT} доступен и выбран."
                break
            fi
        else
            warn_msg "Неверный формат порта. Порт должен быть числом от 1024 до 65535."
        fi
    done
}

# Запрос мастер-ключа LiteLLM
function get_litellm_master_key() {
    echo -e "\n${BLUE}--- Настройка LiteLLM ---${NC}"
    read -s -p "Введите мастер-ключ для LiteLLM (будет использоваться для доступа к прокси, нажмите Enter для автогенерации): " LITELLM_MASTER_KEY
    echo
    if [[ -z "$LITELLM_MASTER_KEY" ]]; then
        LITELLM_MASTER_KEY=$(openssl rand -hex 16)
        success_msg "Мастер-ключ LiteLLM автоматически сгенерирован: ${LITELLM_MASTER_KEY}"
    else
        success_msg "Мастер-ключ LiteLLM установлен."
    fi
}

# Интерактивный выбор LLM
declare -A LLM_OPTIONS
LLM_OPTIONS["gigachat"]="GigaChat (Lite)"
LLM_OPTIONS["openai"]="OpenAI (GPT-5-nano)"
LLM_OPTIONS["anthropic"]="Anthropic (Haiku 4.5)"
LLM_OPTIONS["deepseek"]="DeepSeek (deepseek-chat)"

LLM_IDS=("gigachat" "openai" "anthropic" "deepseek")
declare -A LLM_API_KEYS
SELECTED_LLMS=()
PRIORITIZED_LLMS=()

function select_llms() {
    echo -e "\n${BLUE}--- Выбор языковых моделей (LLM) ---${NC}"
    echo "Выберите LLM, которые вы хотите использовать (введите номера через пробел, например: 1 3):"
    local i=1
    for id in "${LLM_IDS[@]}"; do
        echo "  $i) ${LLM_OPTIONS[$id]}"
        i=$((i+1))
    done

    local choices_str
    read -p "Ваш выбор: " choices_str

    for choice in $choices_str; do
        if [[ $choice -ge 1 && $choice -le ${#LLM_IDS[@]} ]]; then
            SELECTED_LLMS+=("${LLM_IDS[$((choice-1))]}")
        fi
    done

    if [[ ${#SELECTED_LLMS[@]} -eq 0 ]]; then
        error_exit "Вы не выбрали ни одной LLM. Установка невозможна без выбора хотя бы одной модели."
    fi
    success_msg "Выбраны LLM: ${SELECTED_LLMS[@]}"
}

# Запрос API-ключей
function get_api_keys() {
    echo -e "\n${BLUE}--- Ввод и проверка API-ключей ---${NC}"
    for id in "${SELECTED_LLMS[@]}"; do
        local valid_key=0
        while [[ $valid_key -eq 0 ]]; do
            case "$id" in
                "gigachat")
                    read -p "Введите Client ID для GigaChat: " GIGACHAT_CLIENT_ID
                    read -s -p "Введите Client Secret для GigaChat: " GIGACHAT_CLIENT_SECRET
                    echo
                    if [[ -z "$GIGACHAT_CLIENT_ID" || -z "$GIGACHAT_CLIENT_SECRET" ]]; then
                        warn_msg "Client ID или Client Secret для GigaChat не введены. Пропускаем проверку."
                        valid_key=1 # Пропускаем проверку, если пользователь не ввел данные
                    elif validate_gigachat_key "$GIGACHAT_CLIENT_ID" "$GIGACHAT_CLIENT_SECRET"; then
                        LLM_API_KEYS["gigachat"]="$(echo -n "${GIGACHAT_CLIENT_ID}:${GIGACHAT_CLIENT_SECRET}" | base64)"
                        valid_key=1
                    else
         
(Content truncated due to size limit. Use line ranges to read remaining content)

<system_reminder>
The context has been compacted to fit within token limits and maintain system performance.
Some previous tool use records have been replaced by <compacted_history>, and related files, images, and skills have been removed from context.
If you need to access any files or skills that were used earlier in the task, you must re-read them before proceeding.
</system_reminder>
RED=\033[0;31m
GREEN=\033[0;32m
YELLOW=\033[0;33m
BLUE=\033[0;34m
NC=\033[0m # No Color

# --- Переменные ---
LITELLM_DIR="/opt/litellm"
LITELLM_CONFIG_PATH="${LITELLM_DIR}/config.yaml"
LITELLM_SERVICE_PATH="/etc/systemd/system/litellm.service"
LITELLM_PORT=4000 # Порт по умолчанию
OPENCLAW_INSTALL_SCRIPT="https://raw.githubusercontent.com/openclaw/openclaw/main/install.sh" # Placeholder, replace with actual if available

# --- Функции ---

# Функция для очистки при прерывании
function cleanup() {
    warn_msg "\nУстановка прервана. Запускается очистка..."
    # Здесь можно добавить команды для удаления временных файлов, если они есть
    info_msg "Если установка была частичной, вы можете удалить директорию ${LITELLM_DIR} вручную."
    exit 1
}

trap cleanup INT TERM

# Вспомогательная функция для выполнения HTTP-запросов
function make_api_request() {
    local url="$1"
    local headers="$2"
    local data="$3"
    local method="$4"
    local timeout="$5"

    local response=$(curl -s -o /dev/null -w "%{http_code}" -X "$method" -H "Content-Type: application/json" ${headers} "$url" -d "$data" --insecure --max-time ${timeout:-10})
    local http_code=$(echo "$response" | tail -n 1)
    echo "$http_code"
}

# Вспомогательная функция для выполнения HTTP-запросов с получением тела ответа
function make_api_request_with_body() {
    local url="$1"
    local headers="$2"
    local data="$3"
    local method="$4"
    local timeout="$5"

    local response_body=$(curl -s -X "$method" -H "Content-Type: application/json" ${headers} "$url" -d "$data" --insecure --max-time ${timeout:-10})
    local http_code=$(echo "$response_body" | head -n 1 | grep -oP "(?<=HTTP/\S+\s)\d+") # Attempt to extract HTTP code if present
    if [[ -z "$http_code" ]]; then
        # If no HTTP code in body, try to get it from header (less reliable for -s)
        http_code=$(curl -s -o /dev/null -w "%{http_code}" -X "$method" -H "Content-Type: application/json" ${headers} "$url" -d "$data" --insecure --max-time ${timeout:-10})
    fi

    echo "$http_code"
    echo "$response_body"
}

# Проверка GigaChat API Key
function validate_gigachat_key() {
    local client_id="$1"
    local client_secret="$2"

    info_msg "Проверка GigaChat API-ключа..."

    local auth_data="{\"client_id\": \"${client_id}\", \"client_secret\": \"${client_secret}\", \"scope\": \"GIGACHAT_API_PERS\"}"
    local auth_response_raw=$(curl -s -X POST -H "Content-Type: application/json" -H "Accept: application/json" -d "${auth_data}" https://ngw.devices.sberbank.ru:9443/api/v2/oauth --insecure --max-time 15)
    local access_token=$(echo "$auth_response_raw" | jq -r ".access_token" 2>/dev/null)

    if [[ -z "$access_token" || "$access_token" == "null" ]]; then
        warn_msg "Не удалось получить токен GigaChat. Проверьте Client ID и Client Secret. Ответ: ${auth_response_raw}"
        return 1
    fi

    local headers="Authorization: Bearer ${access_token}"
    local check_url="https://gigachat.devices.sberbank.ru/api/v1/models"
    local http_code=$(make_api_request "$check_url" "-H \"${headers}\"" "" "GET" 10)

    if [[ "$http_code" -eq 200 ]]; then
        success_msg "GigaChat API-ключ валиден."
        return 0
    else
        warn_msg "GigaChat API-ключ невалиден или недоступен (HTTP статус: ${http_code})."
        return 1
    fi
}

# Проверка OpenAI API Key
function validate_openai_key() {
    local api_key="$1"

    info_msg "Проверка OpenAI API-ключа..."

    local headers="Authorization: Bearer ${api_key}"
    local check_url="https://api.openai.com/v1/models"
    local http_code=$(make_api_request "$check_url" "-H \"${headers}\"" "" "GET" 10)

    if [[ "$http_code" -eq 200 ]]; then
        success_msg "OpenAI API-ключ валиден."
        return 0
    elif [[ "$http_code" -eq 401 ]]; then
        warn_msg "OpenAI API-ключ невалиден (HTTP статус: 401 Unauthorized)."
        return 1
    else
        warn_msg "OpenAI API-ключ невалиден или недоступен (HTTP статус: ${http_code})."
        return 1
    fi
}

# Проверка Anthropic API Key
function validate_deepseek_key() {
    local api_key="$1"

    info_msg "Проверка DeepSeek API-ключа..."

    local headers="Authorization: Bearer ${api_key}"
    local check_url="https://api.deepseek.com/v1/models"
    local http_code=$(make_api_request "$check_url" "-H \"${headers}\"" "" "GET" 10)

    if [[ "$http_code" -eq 200 ]]; then
        success_msg "DeepSeek API-ключ валиден."
        return 0
    elif [[ "$http_code" -eq 401 ]]; then
        warn_msg "DeepSeek API-ключ невалиден (HTTP статус: 401 Unauthorized)."
        return 1
    else
        warn_msg "DeepSeek API-ключ невалиден или недоступен (HTTP статус: ${http_code})."
        return 1
    fi
}

function validate_anthropic_key() {
    local api_key="$1"

    info_msg "Проверка Anthropic API-ключа..."

    local headers="x-api-key: ${api_key}"
    local check_url="https://api.anthropic.com/v1/models"
    local http_code=$(make_api_request "$check_url" "-H \"${headers}\"" "" "GET" 10)

    if [[ "$http_code" -eq 200 ]]; then
        success_msg "Anthropic API-ключ валиден."
        return 0
    elif [[ "$http_code" -eq 401 ]]; then
        warn_msg "Anthropic API-ключ невалиден (HTTP статус: 401 Unauthorized)."
        return 1
    else
        warn_msg "Anthropic API-ключ невалиден или недоступен (HTTP статус: ${http_code})."
        return 1
    fi
}

# Проверка прав root
function check_root() {
    if [[ $EUID -ne 0 ]]; then
        error_exit "Этот скрипт должен быть запущен от имени root (используйте sudo)."
    fi
    success_msg "Проверка прав root пройдена."
}

# Проверка ОС (Debian/Ubuntu)
function check_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS_NAME=$NAME
        OS_VERSION_ID=$VERSION_ID
    else
        error_exit "Не удалось определить операционную систему. Скрипт поддерживает только Debian/Ubuntu."
    fi

    if [[ "$OS_NAME" != "Ubuntu" && "$OS_NAME" != "Debian GNU/Linux" ]]; then
        error_exit "Скрипт поддерживает только Debian и Ubuntu. Обнаружена: $OS_NAME"
    fi
    success_msg "ОС $OS_NAME $VERSION_ID обнаружена и поддерживается."
}

# Установка необходимых пакетов
function install_dependencies() {
    info_msg "Обновление списка пакетов и установка зависимостей..."
    apt update || error_exit "Не удалось обновить список пакетов."
    apt install -y python3-venv python3-pip git curl jq openssl iproute2 || error_exit "Не удалось установить необходимые пакеты."
    success_msg "Все зависимости установлены."
}

# Запрос порта LiteLLM
function get_litellm_port() {
    echo -e "\n${BLUE}--- Настройка порта LiteLLM ---${NC}"
    while true; do
        read -p "Введите порт для LiteLLM (по умолчанию 4000): " input_port
        input_port=${input_port:-4000} # Если пусто, используем 4000

        if [[ "$input_port" =~ ^[0-9]+$ ]] && ((input_port >= 1024 && input_port <= 65535)); then
            info_msg "Проверка доступности порта ${input_port} для LiteLLM..."
            if ss -tuln | grep -q ":${input_port} "; then
                warn_msg "Порт ${input_port} уже занят. Пожалуйста, выберите другой порт."
            else
                LITELLM_PORT=$input_port
                success_msg "Порт ${LITELLM_PORT} доступен и выбран."
                break
            fi
        else
            warn_msg "Неверный формат порта. Порт должен быть числом от 1024 до 65535."
        fi
    done
}

# Запрос мастер-ключа LiteLLM
function get_litellm_master_key() {
    echo -e "\n${BLUE}--- Настройка LiteLLM ---${NC}"
    read -s -p "Введите мастер-ключ для LiteLLM (будет использоваться для доступа к прокси, нажмите Enter для автогенерации): " LITELLM_MASTER_KEY
    echo
    if [[ -z "$LITELLM_MASTER_KEY" ]]; then
        LITELLM_MASTER_KEY=$(openssl rand -hex 16)
        success_msg "Мастер-ключ LiteLLM автоматически сгенерирован: ${LITELLM_MASTER_KEY}"
    else
        success_msg "Мастер-ключ LiteLLM установлен."
    fi
}

# Интерактивный выбор LLM
declare -A LLM_OPTIONS
LLM_OPTIONS["gigachat"]="GigaChat (Lite)"
LLM_OPTIONS["openai"]="OpenAI (GPT-5-nano)"
LLM_OPTIONS["anthropic"]="Anthropic (Haiku 4.5)"
LLM_OPTIONS["deepseek"]="DeepSeek (deepseek-chat)"

LLM_IDS=("gigachat" "openai" "anthropic" "deepseek")
declare -A LLM_API_KEYS
SELECTED_LLMS=()
PRIORITIZED_LLMS=()

function select_llms() {
    echo -e "\n${BLUE}--- Выбор языковых моделей (LLM) ---${NC}"
    echo "Выберите LLM, которые вы хотите использовать (введите номера через пробел, например: 1 3):"
    local i=1
    for id in "${LLM_IDS[@]}"; do
        echo "  $i) ${LLM_OPTIONS[$id]}"
        i=$((i+1))
    done

    local choices_str
    read -p "Ваш выбор: " choices_str

    for choice in $choices_str; do
        if [[ $choice -ge 1 && $choice -le ${#LLM_IDS[@]} ]]; then
            SELECTED_LLMS+=("${LLM_IDS[$((choice-1))]}")
        fi
    done

    if [[ ${#SELECTED_LLMS[@]} -eq 0 ]]; then
        error_exit "Вы не выбрали ни одной LLM. Установка невозможна без выбора хотя бы одной модели."
    fi
    success_msg "Выбраны LLM: ${SELECTED_LLMS[@]}"
}

# Запрос API-ключей
function get_api_keys() {
    echo -e "\n${BLUE}--- Ввод и проверка API-ключей ---${NC}"
    for id in "${SELECTED_LLMS[@]}"; do
        local valid_key=0
        while [[ $valid_key -eq 0 ]]; do
            case "$id" in
                "gigachat")
                    read -p "Введите Client ID для GigaChat: " GIGACHAT_CLIENT_ID
                    read -s -p "Введите Client Secret для GigaChat: " GIGACHAT_CLIENT_SECRET
                    echo
                    if [[ -z "$GIGACHAT_CLIENT_ID" || -z "$GIGACHAT_CLIENT_SECRET" ]]; then
                        warn_msg "Client ID или Client Secret для GigaChat не введены. Пропускаем проверку."
                        valid_key=1 # Пропускаем проверку, если пользователь не ввел данные
                    elif validate_gigachat_key "$GIGACHAT_CLIENT_ID" "$GIGACHAT_CLIENT_SECRET"; then
                        LLM_API_KEYS["gigachat"]="$(echo -n "${GIGACHAT_CLIENT_ID}:${GIGACHAT_CLIENT_SECRET}" | base64)"
                        valid_key=1
                    else
                        read -p "Попробовать снова? (y/n): " retry
                        if [[ ! "$retry" =~ ^[Yy]$ ]]; then
                            warn_msg "Проверка GigaChat пропущена. Возможны проблемы в работе."
                            valid_key=1
                        fi
                    fi
                    ;;
                "openai")
                    read -s -p "Введите API Key для OpenAI (sk-...): " OPENAI_API_KEY
                    echo
                    if [[ -z "$OPENAI_API_KEY" ]]; then
                        warn_msg "API Key для OpenAI не введен. Пропускаем проверку."
                        valid_key=1
                    elif validate_openai_key "$OPENAI_API_KEY"; then
                        LLM_API_KEYS["openai"]="${OPENAI_API_KEY}"
                        valid_key=1
                    else
                        read -p "Попробовать снова? (y/n): " retry
                        if [[ ! "$retry" =~ ^[Yy]$ ]]; then
                            warn_msg "Проверка OpenAI пропущена. Возможны проблемы в работе."
                            valid_key=1
                        fi
                    fi
                    ;;
                "anthropic")
                    read -s -p "Введите API Key для Anthropic (sk-ant-...): " ANTHROPIC_API_KEY
                    echo
                    if [[ -z "$ANTHROPIC_API_KEY" ]]; then
                        warn_msg "API Key для Anthropic не введен. Пропускаем проверку."
                        valid_key=1
                    elif validate_anthropic_key "$ANTHROPIC_API_KEY"; then
                        LLM_API_KEYS["anthropic"]="${ANTHROPIC_API_KEY}"
                        valid_key=1
                    else
                        read -p "Попробовать снова? (y/n): " retry
                        if [[ ! "$retry" =~ ^[Yy]$ ]]; then
                            warn_msg "Проверка Anthropic пропущена. Возможны проблемы в работе."
                            valid_key=1
                        fi
                    fi
                    ;;
                "deepseek")
                    read -s -p "Введите API Key для DeepSeek (sk-...): " DEEPSEEK_API_KEY
                    echo
                    if [[ -z "$DEEPSEEK_API_KEY" ]]; then
                        warn_msg "API Key для DeepSeek не введен. Пропускаем проверку."
                        valid_key=1
                    elif validate_deepseek_key "$DEEPSEEK_API_KEY"; then
                        LLM_API_KEYS["deepseek"]="${DEEPSEEK_API_KEY}"
                        valid_key=1
                    else
                        read -p "Попробовать снова? (y/n): " retry
                        if [[ ! "$retry" =~ ^[Yy]$ ]]; then
                            warn_msg "Проверка DeepSeek пропущена. Возможны проблемы в работе."
                            valid_key=1
                        fi
                    fi
                    ;;
            esac
        done
        success_msg "API-ключ для ${LLM_OPTIONS[$id]} получен и проверен (или пропущен)."
    done
}
                    read -s -p "Введите API Key для OpenAI (sk-...): " OPENAI_API_KEY
                    echo
                    if [[ -z "$OPENAI_API_KEY" ]]; then
                        warn_msg "API Key для OpenAI не введен. Пропускаем проверку."
                        valid_key=1
                    elif validate_openai_key "$OPENAI_API_KEY"; then
                        LLM_API_KEYS["openai"]="${OPENAI_API_KEY}"
                        valid_key=1
                    else
                        read -p "Попробовать снова? (y/n): " retry
                        if [[ ! "$retry" =~ ^[Yy]$ ]]; then
                            warn_msg "Проверка OpenAI пропущена. Возможны проблемы в работе."
                            valid_key=1
                        fi
                    fi
                    ;;
                "anthropic")
                    read -s -p "Введите API Key для Anthropic (sk-ant-...): " ANTHROPIC_API_KEY
                    echo
                    if [[ -z "$ANTHROPIC_API_KEY" ]]; then
                        warn_msg "API Key для Anthropic не введен. Пропускаем проверку."
                        valid_key=1
                    elif validate_anthropic_key "$ANTHROPIC_API_KEY"; then
                        LLM_API_KEYS["anthropic"]="${ANTHROPIC_API_KEY}"
                        valid_key=1
                    else
                        read -p "Попробовать снова? (y/n): " retry
                        if [[ ! "$retry" =~ ^[Yy]$ ]]; then
                            warn_msg "Проверка Anthropic пропущена. Возможны проблемы в работе."
                            valid_key=1
                        fi
                    fi
                    ;;
            esac
        done
        success_msg "API-ключ для ${LLM_OPTIONS[$id]} получен и проверен (или пропущен)."
    done
}

# Запрос приоритетов LLM
function prioritize_llms() {
    if [[ ${#SELECTED_LLMS[@]} -le 1 ]]; then
        PRIORITIZED_LLMS=("${SELECTED_LLMS[@]}")
        return
    fi

    echo -e "\n${BLUE}--- Установка приоритетов LLM ---${NC}"
    warn_msg "Вы выбрали несколько LLM. LiteLLM будет использовать их в порядке приоритета (fallback)."
    warn_msg "Например, если первая модель недоступна, запрос пойдет ко второй и т.д."

    local remaining_llms=("${SELECTED_LLMS[@]}")
    local count=1

    while [[ ${#remaining_llms[@]} -gt 0 ]]; do
        echo "\nВыберите LLM для ${count}-го приоритета:"
        local i=1
        local current_ids=()

        for id in "${remaining_llms[@]}"; do
            echo "  $i) ${LLM_OPTIONS[$id]}"
            current_ids+=("$id")
            i=$((i+1))
        done

        local choice
        read -p "Ваш выбор (номер): " choice

        if [[ $choice -ge 1 && $choice -le ${#current_ids[@]} ]]; then
            local chosen_id="${current_ids[$((choice-1))]}"
            PRIORITIZED_LLMS+=("$chosen_id")
            success_msg "${LLM_OPTIONS[$chosen_id]} установлен как ${count}-й приоритет."

            # Удаляем выбранную LLM из списка оставшихся
            local new_remaining=()
            for id_rem in "${remaining_llms[@]}"; do
                if [[ "$id_rem" != "$chosen_id" ]]; then
                    new_remaining+=("$id_rem")
                fi
            done
            remaining_llms=("${new_remaining[@]}")
            count=$((count+1))
        else
            warn_msg "Неверный выбор. Пожалуйста, введите корректный номер из списка."
        fi
    done
}

# Генерация конфига LiteLLM
function generate_litellm_config() {
    info_msg "Генерация конфигурационного файла LiteLLM..."
    mkdir -p "${LITELLM_DIR}" || error_exit "Не удалось создать директорию ${LITELLM_DIR}"

    local config_content=""
    local model_list_section=""
    local router_models_list=""

    for id in "${PRIORITIZED_LLMS[@]}"; do
        case "$id" in
            "gigachat")
                model_list_section+="
  - model_name: gigachat-lite
    litellm_params:
      model: gigachat/GigaChat-2
      api_key: \"os.environ/GIGACHAT_CREDENTIALS\"
      ssl_verify: False"
                router_models_list+="\"gigachat-lite\", "
                ;;
            "openai")
                model_list_section+="
  - model_name: openai-nano
    litellm_params:
      model: openai/gpt-5-nano
      api_key: \"os.environ/OPENAI_API_KEY\"
      # base_url: \"https://api.openai.com/v1\" # Если нужен кастомный base_url
      # optional_params:
      #   temperature: 0.7"
                router_models_list+="\"openai-nano\", "
                ;;
            "anthropic")
                model_list_section+="
  - model_name: anthropic-haiku
    litellm_params:
      model: anthropic/claude-haiku-4-5
      api_key: \"os.environ/ANTHROPIC_API_KEY\"
      # base_url: \"https://api.anthropic.com/v1\" # Если нужен кастомный base_url
      # optional_params:
      #   temperature: 0.7"
                router_models_list+="\"anthropic-haiku\", "
                ;;
            "deepseek")
                model_list_section+="
  - model_name: deepseek-chat
    litellm_params:
      model: deepseek/deepseek-chat
      api_key: \"os.environ/DEEPSEEK_API_KEY\"
      # base_url: \"https://api.deepseek.com/v1\" # Если нужен кастомный base_url
      # optional_params:
      #   temperature: 0.7"
                router_models_list+="\"deepseek-chat\", "
                ;;
        esac
    done

    # Удаляем последнюю запятую и пробел из списка роутера
    router_models_list=$(echo "$router_models_list" | sed 's/, $//')

    config_content="model_list:\n${model_list_section}\n\nlitellm_settings:\n  master_key: \"${LITELLM_MASTER_KEY}\"\n\nrouter_settings:\n  routing_strategy: \"priority\"\n  model_group_alias:\n    - model_group: \"openclaw-brain\"\n      models: [${router_models_list}]\n"

    echo -e "$config_content" > "${LITELLM_CONFIG_PATH}"
    chmod 600 "${LITELLM_CONFIG_PATH}" || error_exit "Не удалось установить права на конфиг LiteLLM."
    success_msg "Конфигурационный файл LiteLLM создан: ${LITELLM_CONFIG_PATH}"
}

# Установка LiteLLM в venv и настройка systemd
function install_litellm() {
    info_msg "Установка LiteLLM в виртуальное окружение..."
    python3 -m venv "${LITELLM_DIR}/venv" || error_exit "Не удалось создать виртуальное окружение."
    source "${LITELLM_DIR}/venv/bin/activate" || error_exit "Не удалось активировать виртуальное окружение."
    pip install 'litellm[proxy]' || error_exit "Не удалось установить LiteLLM."
    deactivate
    success_msg "LiteLLM установлен в ${LITELLM_DIR}/venv."

    info_msg "Создание systemd сервиса для LiteLLM..."
    cat > "${LITELLM_SERVICE_PATH}" << EOF
[Unit]
Description=LiteLLM Proxy Server
After=network.target

[Service]
User=root
Group=root
WorkingDirectory=${LITELLM_DIR}
Environment="GIGACHAT_CREDENTIALS=${LLM_API_KEYS[gigachat]}"
Environment="OPENAI_API_KEY=${LLM_API_KEYS[openai]}"
Environment="ANTHROPIC_API_KEY=${LLM_API_KEYS[anthropic]}"
Environment="DEEPSEEK_API_KEY=${LLM_API_KEYS[deepseek]}"
ExecStart=${LITELLM_DIR}/venv/bin/litellm --config ${LITELLM_CONFIG_PATH} --port ${LITELLM_PORT}
Restart=always
RestartSec=10
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=litellm

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload || error_exit "Не удалось перезагрузить systemd daemon."
    systemctl enable litellm || error_exit "Не удалось включить сервис LiteLLM."
    systemctl start litellm || error_exit "Не удалось запустить сервис LiteLLM."

    info_msg "Ожидание запуска LiteLLM (10 секунд)..."
    sleep 10

    if systemctl is-active --quiet litellm; then
        success_msg "Сервис LiteLLM успешно запущен и активен."
    else
        error_exit "Сервис LiteLLM не смог запуститься. Проверьте логи: journalctl -u litellm"
    fi
}

# Опциональная установка OpenClaw
function install_openclaw_optional() {
    echo -e "\n${BLUE}--- Настройка LiteLLM завершена ---${NC}"
    success_msg "LiteLLM успешно настроен и запущен!"
    info_msg "Адрес API: http://localhost:${LITELLM_PORT}/v1"
    info_msg "Мастер-ключ: ${LITELLM_MASTER_KEY}"
    info_msg "Модель для OpenClaw: openclaw-brain"
    echo -e "--------------------------------------\n"

    read -p "Хотите запустить официальный инсталлятор OpenClaw? (y/n): " install_oc
    if [[ "$install_oc" =~ ^[Yy]$ ]]; then
        info_msg "Передаю управление инсталлятору OpenClaw..."
        # Используем exec для полной передачи управления
        exec curl -sSL ${OPENCLAW_INSTALL_SCRIPT} | sudo bash
    else
        info_msg "Установка OpenClaw пропущена. Вы можете запустить её позже вручную."
    fi
}

# --- Основная логика скрипта ---
function uninstall_litellm() {
    info_msg "Начинается удаление LiteLLM..."
    systemctl stop litellm || warn_msg "Не удалось остановить сервис LiteLLM (возможно, он уже остановлен)."
    systemctl disable litellm || warn_msg "Не удалось отключить сервис LiteLLM."
    rm -f "${LITELLM_SERVICE_PATH}" || warn_msg "Не удалось удалить файл сервиса."
    systemctl daemon-reload
    rm -rf "${LITELLM_DIR}" || error_exit "Не удалось удалить директорию ${LITELLM_DIR}."
    success_msg "LiteLLM успешно удален."
    exit 0
}

function update_litellm() {
    info_msg "Начинается обновление LiteLLM..."
    if [ ! -d "${LITELLM_DIR}/venv" ]; then
        error_exit "Директория ${LITELLM_DIR} не найдена. Нечего обновлять. Запустите установку без флагов."
    fi
    source "${LITELLM_DIR}/venv/bin/activate" || error_exit "Не удалось активировать виртуальное окружение."
    pip install --upgrade 'litellm[proxy]' || error_exit "Не удалось обновить LiteLLM."
    deactivate
    success_msg "LiteLLM успешно обновлен."
    info_msg "Перезапуск сервиса LiteLLM..."
    systemctl restart litellm || error_exit "Не удалось перезапустить сервис LiteLLM."
    success_msg "Сервис LiteLLM перезапущен."
    exit 0
}

main() {
    if [[ "$1" == "--uninstall" ]]; then
        read -p "Вы уверены, что хотите полностью удалить LiteLLM? (y/n): " confirm
        if [[ "$confirm" =~ ^[Yy]$ ]]; then
            uninstall_litellm
        else
            info_msg "Удаление отменено."
            exit 0
        fi
    elif [[ "$1" == "--update" ]]; then
        update_litellm
    fi

    echo -e "${BLUE}--- Запуск инсталлятора LiteLLM и OpenClaw ---${NC}"
    check_root
    check_os
    install_dependencies
    get_litellm_port
    get_litellm_master_key
    select_llms
    get_api_keys
    prioritize_llms
    generate_litellm_config
    install_litellm
    install_openclaw_optional
    echo -e "${BLUE}--- Инсталлятор завершил работу ---${NC}"
}

main "$@"
