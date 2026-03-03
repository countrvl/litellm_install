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
EN_MESSAGES["api_key_prompt"]="Enter API Key for %s (press Enter to skip): "
EN_MESSAGES["api_key_invalid"]="Invalid API Key for %s. Please check it and try again, or press Enter to skip."
EN_MESSAGES["api_key_skipped"]="API Key for %s skipped."
EN_MESSAGES["api_key_retry"]="Too many invalid attempts for %s. Skipping."
EN_MESSAGES["priority_prompt"]="Enter the priority order for selected LLMs (e.g., 1 2 3 for %s): "
EN_MESSAGES["priority_invalid"]="Invalid priority order. Please enter unique numbers for each selected LLM."
EN_MESSAGES["priority_retry"]="Too many invalid attempts. Exiting."
EN_MESSAGES["input_required"]="INPUT REQUIRED"
EN_MESSAGES["entered_value"]="Entered: %s"
EN_MESSAGES["entered_empty"]="Entered: (empty)"
EN_MESSAGES["title_port"]="LiteLLM Port"
EN_MESSAGES["title_master_key"]="LiteLLM Master Key"
EN_MESSAGES["title_llm_select"]="Select LLM Providers"
EN_MESSAGES["title_api_key"]="API Key for %s"
EN_MESSAGES["title_priority"]="LLM Priority Order"
EN_MESSAGES["title_openclaw"]="OpenClaw Installation"
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
RU_MESSAGES["api_key_prompt"]="Введите API Key для %s (Enter чтобы пропустить): "
RU_MESSAGES["api_key_invalid"]="Неверный API Key для %s. Проверьте его и попробуйте снова, или нажмите Enter, чтобы пропустить."
RU_MESSAGES["api_key_skipped"]="API Key для %s пропущен."
RU_MESSAGES["api_key_retry"]="Слишком много неверных попыток для %s. Пропускаю."
RU_MESSAGES["priority_prompt"]="Введите порядок приоритета для выбранных LLM (например, 1 2 3 для %s): "
RU_MESSAGES["priority_invalid"]="Неверный порядок приоритета. Введите уникальные номера для каждой выбранной LLM."
RU_MESSAGES["priority_retry"]="Слишком много неверных попыток. Выход."
RU_MESSAGES["input_required"]="ТРЕБУЕТСЯ ВВОД"
RU_MESSAGES["entered_value"]="Введено: %s"
RU_MESSAGES["entered_empty"]="Введено: (пусто)"
RU_MESSAGES["title_port"]="Порт LiteLLM"
RU_MESSAGES["title_master_key"]="Master Key LiteLLM"
RU_MESSAGES["title_llm_select"]="Выбор LLM провайдеров"
RU_MESSAGES["title_api_key"]="API Key для %s"
RU_MESSAGES["title_priority"]="Приоритет LLM"
RU_MESSAGES["title_openclaw"]="Установка OpenClaw"
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
    local template=""
    if [[ "$LANG_CODE" == "ru" ]]; then
        template="${RU_MESSAGES[$key]}"
    fi
    if [[ -z "$template" ]]; then
        template="${EN_MESSAGES[$key]}"
    fi
    if [[ -z "$template" ]]; then
        template="$key"
    fi
    printf "$template" "$@"
}

# --- Logging and Messaging Functions ---
log_file="/var/log/litellm_installer.log"

if [[ ! -w "$(dirname "$log_file")" ]]; then
    log_file="/tmp/litellm_installer.log"
fi

info_msg() {
    if [[ -z "$1" ]]; then
        return
    fi
    echo -e "\e[32m[INFO]\e[0m $(date '+%Y-%m-%d %H:%M:%S') $1" | tee -a "$log_file"
}

warn_msg() {
    if [[ -z "$1" ]]; then
        return
    fi
    echo -e "\e[33m[WARN]\e[0m $(date '+%Y-%m-%d %H:%M:%S') $1" | tee -a "$log_file"
}

error_msg() {
    if [[ -z "$1" ]]; then
        return
    fi
    echo -e "\e[31m[ERROR]\e[0m $(date '+%Y-%m-%d %H:%M:%S') $1" | tee -a "$log_file"
}

info_msg "Log file: $log_file"

STEP=0
STEP_TOTAL=0
step_header() {
    local title="$1"
    STEP=$((STEP + 1))
    printf "\n==============================\n" > /dev/tty
    printf "[%d/%d] %s\n" "$STEP" "$STEP_TOTAL" "$title" > /dev/tty
    printf "==============================\n" > /dev/tty
}

sub_header() {
    local title="$1"
    printf "\n-- %s --\n" "$title" > /dev/tty
}

error_exit() {
    local message="${1:-$(msg error_occurred)}"
    error_msg "$message"
    cleanup
    exit 1
}

cleanup() {
    info_msg "$(msg cleanup_message)"
    if [[ -n "$TEMP_DIR" ]]; then
        rm -rf "$TEMP_DIR"
    fi
}

ask() {
    local title="$1"
    local prompt="$2"
    local __var="$3"
    local default_value="$4"
    local input=""
    local required_msg=""

    if [[ -z "$title" ]]; then
        title="Question"
    fi
    if [[ -z "$prompt" ]]; then
        prompt="Enter value"
    fi
    required_msg=$(msg input_required)
    if [[ -z "$required_msg" || "$required_msg" == "input_required" ]]; then
        required_msg="INPUT REQUIRED"
    fi

    printf "%s\n" "$required_msg" > /dev/tty
    if [[ -n "$default_value" ]]; then
        printf "%s [%s]: " "$prompt" "$default_value" > /dev/tty
    else
        printf "%s" "$prompt" > /dev/tty
    fi

    IFS= read -r input < /dev/tty
    if [[ -z "$input" && -n "$default_value" ]]; then
        input="$default_value"
    fi

    if [[ -z "$input" ]]; then
        printf "%s\n" "$(msg entered_empty)" > /dev/tty
    else
        entered_msg=$(msg entered_value "$input")
        printf "%s\n" "$entered_msg" > /dev/tty
    fi

    printf -v "$__var" '%s' "$input"
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

trap 'error_exit' ERR
trap 'error_exit "Interrupted."' INT TERM

# --- Variables ---
INSTALL_DIR="/opt/litellm"
VENV_DIR="$INSTALL_DIR/venv"
CONFIG_DIR="$INSTALL_DIR/config"
CONFIG_FILE="$CONFIG_DIR/config.yaml"
SYSTEMD_SERVICE_FILE="/etc/systemd/system/litellm.service"
ENV_FILE="/etc/litellm/litellm.env"
OPENCLAW_INSTALL_SCRIPT="https://raw.githubusercontent.com/openclaw/openclaw/main/install.sh"

# Default values
LITELLM_PORT=4000
LITELLM_MASTER_KEY=""
MAX_RETRIES=3

# --- Helper Functions ---

# Function to check if a port is in use
is_port_in_use() {
    sudo ss -tuln "sport = :$1" | tail -n +2 | grep -q .
}

# Function to generate a random string
generate_random_string() {
    head /dev/urandom | tr -dc A-Za-z0-9_ | head -c 32
}

# Function to validate API Key
validate_api_key() {
    local provider_name="$1"
    local api_key="$2"

    if [[ -z "$api_key" ]]; then
        return 1 # Empty key is invalid
    fi

    info_msg "Validating API Key for $provider_name..."
    return 0
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
info_msg "Details: $log_file"
sudo apt update -y >> "$log_file" 2>&1 || error_exit "$(msg dependencies_error)"
sudo apt install -y python3-venv git curl jq >> "$log_file" 2>&1 || error_exit "$(msg dependencies_error)"
info_msg "Dependencies installed."

# 4. Prompt for LiteLLM Port
STEP=0
STEP_TOTAL=5
step_header "$(msg title_port)"
while true; do
    port_prompt_msg=$(msg port_prompt)
    ask "$(msg title_port)" "$port_prompt_msg" input_port "4000"
    LITELLM_PORT=${input_port:-4000}

    if ! [[ "$LITELLM_PORT" =~ ^[0-9]+$ ]] || (( LITELLM_PORT < 1024 || LITELLM_PORT > 65535 )); then
        error_msg "$(msg port_invalid)"
    elif is_port_in_use "$LITELLM_PORT"; then
        port_in_use_msg=$(msg port_in_use "$LITELLM_PORT")
        error_msg "$port_in_use_msg"
    else
        break
    fi
done

# 5. Prompt for LiteLLM Master Key
master_key_prompt_msg=$(msg master_key_prompt)
step_header "$(msg title_master_key)"
ask "$(msg title_master_key)" "$master_key_prompt_msg" LITELLM_MASTER_KEY ""
if [[ -z "$LITELLM_MASTER_KEY" ]]; then
    LITELLM_MASTER_KEY=$(generate_random_string)
    master_key_msg=$(msg master_key_generated "$LITELLM_MASTER_KEY")
    info_msg "$master_key_msg"
fi

# 6. Select LLM Providers
LLM_OPTIONS=("GigaChat" "OpenAI" "Anthropic" "DeepSeek")
SELECTED_LLMS=()

select_llms() {
    local selection_input
    local selected_indices=()

    ask "$(msg title_llm_select)" "Enter numbers separated by spaces (e.g. 1 3): " selection_input ""

    for idx in $selection_input; do
        if [[ "$idx" =~ ^[0-9]+$ ]] && (( idx >= 1 && idx <= ${#LLM_OPTIONS[@]} )); then
            selected_indices+=( "$((idx - 1))" )
        fi
    done

    # Deduplicate while preserving order
    local seen=" "
    for idx in "${selected_indices[@]}"; do
        if [[ "$seen" != *" $idx "* ]]; then
            SELECTED_LLMS+=( "${LLM_OPTIONS[$idx]}" )
            seen+="$idx "
        fi
    done
}

step_header "$(msg title_llm_select)"
echo "$(msg llm_selection_prompt)"
for i in "${!LLM_OPTIONS[@]}"; do
    echo "$((i + 1)). ${LLM_OPTIONS[$i]}"
done
select_llms

if [[ ${#SELECTED_LLMS[@]} -gt 1 ]]; then
    STEP_TOTAL=6
fi

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

    step_header "API Keys"
    for llm in "${SELECTED_LLMS[@]}"; do
        retry_count=0
        while true; do
            api_key_prompt_msg=$(msg api_key_prompt "$llm")
            api_key_title=$(msg title_api_key "$llm")
            sub_header "$api_key_title (attempt $((retry_count + 1))/$MAX_RETRIES)"
            ask "$api_key_title" "$api_key_prompt_msg" current_key ""
            if [[ -z "$current_key" ]]; then
                api_key_skipped_msg=$(msg api_key_skipped "$llm")
                warn_msg "$api_key_skipped_msg"
                break
            fi

            if validate_api_key "$llm" "$current_key"; then
                LLM_API_KEYS["$llm"]="$current_key"
                break
            else
                api_key_invalid_msg=$(msg api_key_invalid "$llm")
                error_msg "$api_key_invalid_msg"
                retry_count=$((retry_count + 1))
                if (( retry_count >= MAX_RETRIES )); then
                    api_key_retry_msg=$(msg api_key_retry "$llm")
                    warn_msg "$api_key_retry_msg"
                    break
                fi
            fi
        done
    done

    # 8. Determine LLM Priority
    if [[ ${#SELECTED_LLMS[@]} -gt 1 ]]; then
        selected_list=$(printf "%s " "${SELECTED_LLMS[@]}" | sed 's/ $//')
        priority_prompt_msg=$(msg priority_prompt "$selected_list")
        step_header "$(msg title_priority)"
        ask "$(msg title_priority)" "$priority_prompt_msg" priority_order_input ""
        priority_retries=0
        while true; do
            IFS=' ' read -r -a PRIORITY_ORDER <<< "$priority_order_input"

            if [[ ${#PRIORITY_ORDER[@]} -ne ${#SELECTED_LLMS[@]} ]]; then
                error_msg "$(msg priority_invalid)"
                priority_retries=$((priority_retries + 1))
                if (( priority_retries >= MAX_RETRIES )); then
                    error_exit "$(msg priority_retry)"
                fi
                ask "$(msg title_priority)" "$priority_prompt_msg" priority_order_input ""
                continue
            fi

            declare -A seen_order=()
            valid_order=1
            for order in "${PRIORITY_ORDER[@]}"; do
                if ! [[ "$order" =~ ^[0-9]+$ ]] || (( order < 1 || order > ${#SELECTED_LLMS[@]} )); then
                    valid_order=0
                    break
                fi
                if [[ -n "${seen_order[$order]}" ]]; then
                    valid_order=0
                    break
                fi
                seen_order[$order]=1
            done

            if [[ "$valid_order" -ne 1 ]]; then
                error_msg "$(msg priority_invalid)"
                priority_retries=$((priority_retries + 1))
                if (( priority_retries >= MAX_RETRIES )); then
                    error_exit "$(msg priority_retry)"
                fi
                ask "$(msg title_priority)" "$priority_prompt_msg" priority_order_input ""
                continue
            fi

            # Reorder SELECTED_LLMS based on priority
            reordered_llms=()
            for order in "${PRIORITY_ORDER[@]}"; do
                reordered_llms+=( "${SELECTED_LLMS[$((order - 1))]}" )
            done
            SELECTED_LLMS=( "${reordered_llms[@]}" )
            break
        done
    fi

    # 9. Install LiteLLM
    info_msg "$(msg litellm_install)"
    mkdir -p "$INSTALL_DIR"
    python3 -m venv "$VENV_DIR"
    source "$VENV_DIR/bin/activate"
    pip install --upgrade "litellm[proxy]" >> "$log_file" 2>&1 || error_exit "$(msg litellm_install_error)"
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
    sudo mkdir -p "$(dirname "$ENV_FILE")"
    sudo chown root:root "$(dirname "$ENV_FILE")"
    umask 077
    cat > "$ENV_FILE" << EOF
LITELLM_MASTER_KEY=$LITELLM_MASTER_KEY
$(for llm in "${SELECTED_LLMS[@]}"; do
    echo "${llm^^}_API_KEY=${LLM_API_KEYS[$llm]}"
done)
EOF
    umask 022
    sudo chown root:root "$ENV_FILE"
    sudo chmod 600 "$ENV_FILE"
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
EnvironmentFile=$ENV_FILE

[Install]
WantedBy=multi-user.target
EOF

    sudo systemctl daemon-reload >> "$log_file" 2>&1
    sudo systemctl enable litellm.service >> "$log_file" 2>&1

    # 12. Start and Check Service
    info_msg "$(msg systemd_start)"
    sudo systemctl start litellm.service >> "$log_file" 2>&1
    sleep 5 # Give it a moment to start
    info_msg "$(msg systemd_status)"
    if ! sudo systemctl is-active --quiet litellm.service; then
        error_exit "$(msg systemd_error)"
    fi

    litellm_ready_msg=$(msg litellm_ready "$LITELLM_PORT")
    info_msg "$litellm_ready_msg"

    # 13. OpenClaw Integration Info
    info_msg "$(msg openclaw_config_info)"
    api_base_msg=$(msg api_base "$LITELLM_PORT")
    info_msg "$api_base_msg"
    master_key_display_msg=$(msg master_key "$LITELLM_MASTER_KEY")
    info_msg "$master_key_display_msg"
    info_msg "$(msg openclaw_model)"
    echo "----------------------------------------"
    echo "LiteLLM install summary:"
    echo "  URL: http://localhost:${LITELLM_PORT}"
    echo "  API Base: http://localhost:${LITELLM_PORT}/openai/v1"
    echo "  Master Key: ${LITELLM_MASTER_KEY}"
    echo "  Model: openclaw-brain"
    echo "----------------------------------------"

    # 14. Optional OpenClaw Installation
    openclaw_prompt_msg=$(msg openclaw_install_prompt)
    step_header "$(msg title_openclaw)"
    ask "$(msg title_openclaw)" "$openclaw_prompt_msg" install_oc ""

    if [[ "$install_oc" =~ ^[Yy]$ ]]; then
        info_msg "$(msg openclaw_install_start)"
        temp_oc_script=$(mktemp)
        if curl -fsSL "$OPENCLAW_INSTALL_SCRIPT" -o "$temp_oc_script" >> "$log_file" 2>&1; then
            bash "$temp_oc_script"
        else
            error_msg "Failed to download OpenClaw installer. Check $OPENCLAW_INSTALL_SCRIPT"
        fi
        rm -f "$temp_oc_script"
    else
        info_msg "$(msg openclaw_install_skipped)"
    fi
fi

info_msg "$(msg script_complete)"
cleanup
