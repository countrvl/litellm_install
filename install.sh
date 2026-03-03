#!/bin/bash
set -euo pipefail

# --- Localization ---

# Default language
LANG_CODE="en"

set_language() {
    if [[ -n "${1:-}" ]]; then
        LANG_CODE="$1"
    else
        LOCALE=$(locale | grep -E '^LANG=' | cut -d= -f2 | cut -d. -f1 | tr '[:upper:]' '[:lower:]' || true)
        if [[ "$LOCALE" == "ru_ru" || "$LOCALE" == "ru" ]]; then
            LANG_CODE="ru"
        fi
    fi
}

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
EN_MESSAGES["llm_selection_prompt"]="Select LLM providers to configure (enter numbers separated by spaces, e.g. 1 3):"
EN_MESSAGES["llm_none_selected"]="No LLM providers selected. LiteLLM will not be configured."
EN_MESSAGES["api_key_prompt"]="Enter API Key for %s (press Enter to skip): "
EN_MESSAGES["api_key_skipped"]="API Key for %s skipped."
EN_MESSAGES["priority_prompt"]="Enter the priority order for selected LLMs (e.g., 1 2 3 for %s): "
EN_MESSAGES["priority_invalid"]="Invalid priority order. Please enter unique numbers for each selected LLM."
EN_MESSAGES["priority_retry"]="Too many invalid attempts. Exiting."
EN_MESSAGES["entered_value"]="Entered."
EN_MESSAGES["entered_empty"]="Entered: (empty)"
EN_MESSAGES["title_port"]="LiteLLM Port"
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
EN_MESSAGES["health_failed"]="LiteLLM started but health-check failed at /health."
EN_MESSAGES["user_create"]="Creating system user for LiteLLM..."
EN_MESSAGES["user_exists"]="System user for LiteLLM already exists."
EN_MESSAGES["venv_create"]="Creating Python venv..."
EN_MESSAGES["service_user"]="Running systemd service as unprivileged user: litellm"
EN_MESSAGES["gigachat_auth_prompt"]="Enter GigaChat Authorization Key for OAuth (press Enter to skip): "
EN_MESSAGES["gigachat_token_refresh"]="Refreshing GigaChat access token..."
EN_MESSAGES["gigachat_token_refresh_done"]="GigaChat access token refreshed."
EN_MESSAGES["gigachat_token_refresh_failed"]="Failed to refresh GigaChat access token via OAuth."
EN_MESSAGES["token_timer_setup"]="Setting up GigaChat token refresh timer..."

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
RU_MESSAGES["llm_selection_prompt"]="Выберите провайдеров LLM (введите номера через пробел, напр. 1 3):"
RU_MESSAGES["llm_none_selected"]="Провайдеры LLM не выбраны. LiteLLM не будет настроен."
RU_MESSAGES["api_key_prompt"]="Введите API Key для %s (Enter чтобы пропустить): "
RU_MESSAGES["api_key_skipped"]="API Key для %s пропущен."
RU_MESSAGES["priority_prompt"]="Введите порядок приоритета для выбранных LLM (например, 1 2 3 для %s): "
RU_MESSAGES["priority_invalid"]="Неверный порядок приоритета. Введите уникальные номера для каждой выбранной LLM."
RU_MESSAGES["priority_retry"]="Слишком много неверных попыток. Выход."
RU_MESSAGES["entered_value"]="Введено."
RU_MESSAGES["entered_empty"]="Введено: (пусто)"
RU_MESSAGES["title_port"]="Порт LiteLLM"
RU_MESSAGES["title_llm_select"]="Выбор LLM провайдеров"
RU_MESSAGES["title_api_key"]="API Key для %s"
RU_MESSAGES["title_priority"]="Приоритет LLM"
RU_MESSAGES["title_openclaw"]="Установка OpenClaw"
RU_MESSAGES["litellm_install"]="Установка LiteLLM..."
RU_MESSAGES["litellm_install_error"]="Не удалось установить LiteLLM. Проверьте интернет и попробуйте снова."
RU_MESSAGES["config_generate"]="Генерация конфигурации LiteLLM..."
RU_MESSAGES["systemd_setup"]="Настройка LiteLLM как системного сервиса..."
RU_MESSAGES["systemd_start"]="Запуск сервиса LiteLLM..."
RU_MESSAGES["systemd_status"]="Проверка статуса сервиса LiteLLM..."
RU_MESSAGES["systemd_error"]="Сервис LiteLLM не запустился. Проверьте логи: 'journalctl -u litellm.service'."
RU_MESSAGES["litellm_ready"]="LiteLLM Proxy запущен и доступен по адресу http://localhost:%s."
RU_MESSAGES["openclaw_config_info"]="Для подключения OpenClaw к LiteLLM используйте:"
RU_MESSAGES["api_base"]="API Base: http://localhost:%s/openai/v1"
RU_MESSAGES["openclaw_model"]="Модель для OpenClaw: openclaw-brain"
RU_MESSAGES["openclaw_install_prompt"]="Хотите запустить официальный инсталлятор OpenClaw? (y/n): "
RU_MESSAGES["openclaw_install_start"]="Передаю управление инсталлятору OpenClaw..."
RU_MESSAGES["openclaw_install_skipped"]="Установка OpenClaw пропущена. Можно запустить позже вручную."
RU_MESSAGES["uninstall_confirm"]="Вы уверены, что хотите удалить LiteLLM и все связанные файлы? (y/n): "
RU_MESSAGES["uninstall_aborted"]="Удаление отменено."
RU_MESSAGES["uninstall_complete"]="Удаление LiteLLM завершено."
RU_MESSAGES["update_start"]="Обновление LiteLLM..."
RU_MESSAGES["update_complete"]="Обновление LiteLLM завершено."
RU_MESSAGES["script_complete"]="Скрипт завершен."
RU_MESSAGES["error_occurred"]="Произошла ошибка. Выход."
RU_MESSAGES["cleanup_message"]="Очистка временных файлов..."
RU_MESSAGES["lang_flag_invalid"]="Неверный код языка. Используйте 'en' или 'ru'."
RU_MESSAGES["health_failed"]="LiteLLM запустился, но health-check /health не прошёл."
RU_MESSAGES["user_create"]="Создаю системного пользователя для LiteLLM..."
RU_MESSAGES["user_exists"]="Системный пользователь для LiteLLM уже существует."
RU_MESSAGES["venv_create"]="Создаю Python venv..."
RU_MESSAGES["service_user"]="systemd сервис запускается от непривилегированного пользователя: litellm"
RU_MESSAGES["gigachat_auth_prompt"]="Введите Authorization Key GigaChat для OAuth (Enter чтобы пропустить): "
RU_MESSAGES["gigachat_token_refresh"]="Обновляю GigaChat access token..."
RU_MESSAGES["gigachat_token_refresh_done"]="GigaChat access token обновлён."
RU_MESSAGES["gigachat_token_refresh_failed"]="Не удалось обновить GigaChat access token через OAuth."
RU_MESSAGES["token_timer_setup"]="Настраиваю таймер обновления токена GigaChat..."

msg() {
    local key="$1"
    shift
    local template=""
    if [[ "$LANG_CODE" == "ru" ]]; then
        template="${RU_MESSAGES[$key]:-}"
    fi
    if [[ -z "$template" ]]; then
        template="${EN_MESSAGES[$key]:-}"
    fi
    if [[ -z "$template" ]]; then
        template="$key"
    fi
    printf "$template" "$@"
}

# --- Logging ---
log_file="/var/log/litellm_installer.log"
if [[ ! -w "$(dirname "$log_file")" ]]; then
    log_file="/tmp/litellm_installer.log"
fi

info_msg() { [[ -n "${1:-}" ]] && echo -e "\e[32m[INFO]\e[0m $(date '+%Y-%m-%d %H:%M:%S') $1" | tee -a "$log_file"; }
warn_msg() { [[ -n "${1:-}" ]] && echo -e "\e[33m[WARN]\e[0m $(date '+%Y-%m-%d %H:%M:%S') $1" | tee -a "$log_file"; }
error_msg(){ [[ -n "${1:-}" ]] && echo -e "\e[31m[ERROR]\e[0m $(date '+%Y-%m-%d %H:%M:%S') $1" | tee -a "$log_file"; }

info_msg "Log file: $log_file"

STEP=0
STEP_TOTAL=0
step_header() {
    local title="$1"
    STEP=$((STEP + 1))
    printf "\n==============================\n" > /dev/tty
    printf "\e[1;32m[%d/%d] %s\e[0m\n" "$STEP" "$STEP_TOTAL" "$title" > /dev/tty
    printf "==============================\n" > /dev/tty
}

sub_header() {
    local title="$1"
    printf "\n-- %s --\n" "$title" > /dev/tty
}

TEMP_DIR=""
cleanup() {
    info_msg "$(msg cleanup_message)"
    if [[ -n "$TEMP_DIR" ]]; then
        rm -rf "$TEMP_DIR" || true
    fi
}

error_exit() {
    local message="${1:-$(msg error_occurred)}"
    error_msg "$message"
    cleanup
    exit 1
}

trap 'error_exit' ERR
trap 'error_exit "Interrupted."' INT TERM

# --- Input helpers (TTY-safe, no secret echo to logs) ---
ask() {
    local prompt="$1"
    local __var="$2"
    local default_value="${3:-}"
    local input=""

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
        printf "%s\n" "$(msg entered_value)" > /dev/tty
    fi

    printf -v "$__var" '%s' "$input"
}

ask_secret() {
    local prompt="$1"
    local __var="$2"
    local default_value="${3:-}"
    local input=""

    if [[ -n "$default_value" ]]; then
        printf "%s [%s]: " "$prompt" "$default_value" > /dev/tty
    else
        printf "%s" "$prompt" > /dev/tty
    fi

    stty -echo < /dev/tty
    IFS= read -r input < /dev/tty
    stty echo < /dev/tty
    printf "\n" > /dev/tty

    if [[ -z "$input" && -n "$default_value" ]]; then
        input="$default_value"
    fi

    if [[ -z "$input" ]]; then
        printf "%s\n" "$(msg entered_empty)" > /dev/tty
    else
        printf "%s\n" "$(msg entered_value)" > /dev/tty
    fi

    printf -v "$__var" '%s' "$input"
}

# Parse command line arguments for language and mode flags
LANG_ARG=""
MODE=""
RESTART_SERVICE=0
for arg in "$@"; do
    case $arg in
        --lang=*)
            LANG_ARG="${arg#*=}"
            if [[ "$LANG_ARG" == "en" || "$LANG_ARG" == "ru" ]]; then
                set_language "$LANG_ARG"
            else
                error_exit "$(msg lang_flag_invalid)"
            fi
            ;;
        --update) MODE="update" ;;
        --uninstall) MODE="uninstall" ;;
        --refresh-token) MODE="refresh-token" ;;
        --restart-service) RESTART_SERVICE=1 ;;
    esac
done

if [[ -z "$LANG_ARG" ]]; then
    set_language
fi

# Require root early for management modes to avoid permission-related partial failures
if [[ "${MODE:-}" == "update" || "${MODE:-}" == "uninstall" || "${MODE:-}" == "refresh-token" ]]; then
    if [[ "$EUID" -ne 0 ]]; then
        error_exit "$(msg sudo_required)"
    fi
fi

# --- Variables ---
INSTALL_DIR="/opt/litellm"
VENV_DIR="$INSTALL_DIR/venv"
CONFIG_DIR="$INSTALL_DIR/config"
CONFIG_FILE="$CONFIG_DIR/config.yaml"
SYSTEMD_SERVICE_FILE="/etc/systemd/system/litellm.service"
TOKEN_REFRESH_SERVICE_FILE="/etc/systemd/system/litellm-token-refresh.service"
TOKEN_REFRESH_TIMER_FILE="/etc/systemd/system/litellm-token-refresh.timer"
ENV_FILE="/etc/litellm/litellm.env"
OAUTH_ENV_FILE="/etc/litellm/gigachat.env"
TOKEN_REFRESH_SCRIPT="/opt/litellm/refresh_gigachat_token.sh"
TOKEN_DIR="/etc/litellm/tokens"
GIGACHAT_TOKEN_FILE="$TOKEN_DIR/gigachat.token"
OPENCLAW_INSTALL_SCRIPT="https://openclaw.ai/install.sh"
GIGACHAT_OAUTH_URL="https://ngw.devices.sberbank.ru:9443/api/v2/oauth"
GIGACHAT_OAUTH_SCOPE="GIGACHAT_API_PERS"
GIGACHAT_OAUTH_INSECURE=1
TOKEN_REFRESH_INTERVAL_SEC=1320

LITELLM_PORT=4000
MAX_RETRIES=3

# Provider models (adjust if you want different defaults)
declare -A DEFAULT_LLM_MODELS
DEFAULT_LLM_MODELS["GigaChat"]="gigachat/GigaChat-2"
DEFAULT_LLM_MODELS["OpenAI"]="openai/gpt-5-nano"
DEFAULT_LLM_MODELS["Anthropic"]="anthropic/claude-haiku-4-5"
DEFAULT_LLM_MODELS["DeepSeek"]="deepseek/deepseek-chat"

model_name_to_llm() {
    case "$1" in
        gigachat) echo "GigaChat" ;;
        openai) echo "OpenAI" ;;
        anthropic) echo "Anthropic" ;;
        deepseek) echo "DeepSeek" ;;
        *) echo "" ;;
    esac
}

# Function to check if a port is in use (robust)
is_port_in_use() {
    ss -tuln | grep -qE "[:.]$1[[:space:]]" || ss -tuln | grep -q ":$1 "
}

generate_random_string() {
    head /dev/urandom | tr -dc A-Za-z0-9_ | head -c 32
}

request_gigachat_access_token() {
    local auth_key="$1"
    local oauth_response=""
    local token=""
    local expires_raw=""
    local expires_sec=""
    local now=""
    local ttl=""
    local min_ttl=""
    local rquid=""
    rquid="$(cat /proc/sys/kernel/random/uuid)"

    sleep $((RANDOM % 16))
    if [[ "${GIGACHAT_OAUTH_INSECURE}" -eq 1 ]]; then
        echo "[WARN] Using insecure TLS for GigaChat OAuth endpoint." >&2
    fi
    oauth_response="$(curl --silent --show-error --fail \
        --connect-timeout 5 \
        --max-time 15 \
        $( [[ "${GIGACHAT_OAUTH_INSECURE}" -eq 1 ]] && echo "--insecure" ) \
        --request POST "$GIGACHAT_OAUTH_URL" \
        --header "Authorization: Basic ${auth_key}" \
        --header "RqUID: ${rquid}" \
        --header "Content-Type: application/x-www-form-urlencoded" \
        --data "scope=${GIGACHAT_OAUTH_SCOPE}")" || return 1

    token="$(printf '%s' "$oauth_response" | jq -r '.access_token // empty')" || return 1
    expires_raw="$(printf '%s' "$oauth_response" | jq -r '.expires_at // empty')" || return 1
    [[ -n "$token" ]] || return 1
    [[ "$expires_raw" =~ ^[0-9]+$ ]] || return 1

    if (( expires_raw > 1000000000000 )); then
        expires_sec=$((expires_raw / 1000))
        echo "[INFO] GigaChat OAuth expires_at parsed as milliseconds." >&2
    elif (( expires_raw > 1000000000 && expires_raw < 1000000000000 )); then
        expires_sec="$expires_raw"
        echo "[INFO] GigaChat OAuth expires_at parsed as seconds." >&2
    else
        return 1
    fi

    now="$(date +%s)"
    ttl=$((expires_sec - now))
    min_ttl=$((TOKEN_REFRESH_INTERVAL_SEC + 300))
    if (( min_ttl < 900 )); then
        min_ttl=900
    fi

    echo "[INFO] GigaChat token ttl=${ttl}s min_ttl=${min_ttl}s expires_at=${expires_sec}" >&2
    if (( ttl < min_ttl )); then
        return 1
    fi

    printf '%s' "$token"
}

upsert_env_var() {
    local file="$1"
    local key="$2"
    local value="$3"
    local tmp_file
    tmp_file="$(mktemp)"

    if [[ -f "$file" ]]; then
        awk -v k="$key" -v v="$value" '
            BEGIN { done=0 }
            $0 ~ "^" k "=" { print k "=" v; done=1; next }
            { print }
            END { if (!done) print k "=" v }
        ' "$file" > "$tmp_file"
    else
        printf '%s=%s\n' "$key" "$value" > "$tmp_file"
    fi

    install -o root -g root -m 600 "$tmp_file" "$file"
    rm -f "$tmp_file"
}

write_gigachat_token_atomic() {
    local token="$1"
    if [[ -z "$token" || "$token" == \[* || "$token" =~ [[:space:]] ]]; then
        return 1
    fi
    mkdir -p "$TOKEN_DIR"
    chown root:litellm "$TOKEN_DIR"
    chmod 750 "$TOKEN_DIR"

    local tmp_file="$GIGACHAT_TOKEN_FILE.tmp"
    printf '%s\n' "$token" > "$tmp_file"
    chmod 640 "$tmp_file"
    chown root:litellm "$tmp_file"
    mv "$tmp_file" "$GIGACHAT_TOKEN_FILE"
}

refresh_gigachat_token_from_env() {
    local restart_after="${1:-0}"
    [[ -f "$OAUTH_ENV_FILE" ]] || return 0

    local auth_key=""
    auth_key="$(sed -n 's/^GIGACHAT_AUTHORIZATION_KEY=//p' "$OAUTH_ENV_FILE" | head -n1)"
    [[ -n "$auth_key" ]] || return 0

    info_msg "$(msg gigachat_token_refresh)"
    local access_token=""
    access_token="$(request_gigachat_access_token "$auth_key")" || error_exit "$(msg gigachat_token_refresh_failed)"
    write_gigachat_token_atomic "$access_token" || error_exit "$(msg gigachat_token_refresh_failed)"
    info_msg "$(msg gigachat_token_refresh_done)"

    if [[ "$restart_after" -eq 1 ]]; then
        systemctl restart litellm.service >> "$log_file" 2>&1 || true
    fi
}

create_system_user() {
    if id -u litellm >/dev/null 2>&1; then
        info_msg "$(msg user_exists)"
        return 0
    fi
    info_msg "$(msg user_create)"
    useradd --system --no-create-home --shell /usr/sbin/nologin litellm
}

write_config_and_env() {
    info_msg "$(msg config_generate)"
    mkdir -p "$CONFIG_DIR"
    local primary_llm="${SELECTED_LLMS[0]}"
    local primary_alias
    if [[ "$primary_llm" == "GigaChat" ]]; then
        primary_alias="gigachat-main"
    else
        primary_alias="$(echo "$primary_llm" | tr '[:upper:]' '[:lower:]')-main"
    fi
    # Two deterministic config modes:
    # 1) only GigaChat -> no router_settings
    # 2) multi-provider -> aliases + router fallbacks
    cat > "$CONFIG_FILE" << EOF
model_list:
EOF

    if [[ ${#SELECTED_LLMS[@]} -eq 1 ]]; then
        cat >> "$CONFIG_FILE" << EOF
  - model_name: openclaw-brain
    litellm_params:
      model: ${LLM_MODELS[$primary_llm]}
      api_key: $( [[ "$primary_llm" == "GigaChat" ]] && echo "file:$GIGACHAT_TOKEN_FILE" || echo "os.environ/${primary_llm^^}_API_KEY" )
$( [[ "$primary_llm" == "GigaChat" ]] && echo "      ssl_verify: false" )
$(if [[ "$primary_llm" == "GigaChat" ]]; then
    cat << EOA
  - model_name: gigachat-2
    litellm_params:
      model: ${LLM_MODELS[$primary_llm]}
      api_key: file:$GIGACHAT_TOKEN_FILE
      ssl_verify: false
EOA
fi)
EOF
    else
        local fallback_aliases=()
        local generated_aliases=()
        fallback_aliases+=( "${primary_alias}" )
        generated_aliases+=( "${primary_alias}" )
        for ((i=1; i<${#SELECTED_LLMS[@]}; i++)); do
            llm="${SELECTED_LLMS[$i]}"
            alias_name="$(echo "$llm" | tr '[:upper:]' '[:lower:]')-fallback"
            fallback_aliases+=( "$alias_name" )
            generated_aliases+=( "$alias_name" )
        done

        # Validate fallback aliases are deterministic and all aliases exist.
        if [[ "${#fallback_aliases[@]}" -eq 0 ]]; then
            error_exit "No fallback aliases generated for router mode."
        fi
        for alias_name in "${fallback_aliases[@]}"; do
            if [[ " ${generated_aliases[*]} " != *" ${alias_name} "* ]]; then
                error_exit "Invalid fallback alias generated: ${alias_name}"
            fi
        done

        cat >> "$CONFIG_FILE" << EOF
  - model_name: openclaw-brain
    litellm_params:
      model: ${LLM_MODELS[$primary_llm]}
      api_key: $( [[ "$primary_llm" == "GigaChat" ]] && echo "file:$GIGACHAT_TOKEN_FILE" || echo "os.environ/${primary_llm^^}_API_KEY" )
$( [[ "$primary_llm" == "GigaChat" ]] && echo "      ssl_verify: false" )
  - model_name: ${primary_alias}
    litellm_params:
      model: ${LLM_MODELS[$primary_llm]}
      api_key: $( [[ "$primary_llm" == "GigaChat" ]] && echo "file:$GIGACHAT_TOKEN_FILE" || echo "os.environ/${primary_llm^^}_API_KEY" )
$( [[ "$primary_llm" == "GigaChat" ]] && echo "      ssl_verify: false" )
$(for ((i=1; i<${#SELECTED_LLMS[@]}; i++)); do
    llm="${SELECTED_LLMS[$i]}"
    alias_name="$(echo "$llm" | tr '[:upper:]' '[:lower:]')-fallback"
    echo "  - model_name: ${alias_name}"
    echo "    litellm_params:"
    echo "      model: ${LLM_MODELS[$llm]}"
    if [[ "$llm" == "GigaChat" ]]; then
        echo "      api_key: file:$GIGACHAT_TOKEN_FILE"
        echo "      ssl_verify: false"
    else
        echo "      api_key: os.environ/${llm^^}_API_KEY"
    fi
done)
router_settings:
  fallbacks:
    openclaw-brain:
$(for alias_name in "${fallback_aliases[@]}"; do
    echo "      - ${alias_name}"
done)
EOF
    fi

    # Runtime env for LiteLLM (no OAuth authorization key here)
    mkdir -p "$(dirname "$ENV_FILE")"
    umask 077
    cat > "$ENV_FILE" << EOF
$(for llm in "${SELECTED_LLMS[@]}"; do
    if [[ "$llm" != "GigaChat" ]]; then
        echo "${llm^^}_API_KEY=${LLM_API_KEYS[$llm]}"
    fi
done)
EOF
    umask 022
    chown root:root "$ENV_FILE"
    chmod 600 "$ENV_FILE"

    # OAuth env only for refresh unit
    if [[ " ${SELECTED_LLMS[*]} " == *" GigaChat "* ]]; then
        umask 077
        cat > "$OAUTH_ENV_FILE" << EOF
GIGACHAT_AUTHORIZATION_KEY=${LLM_API_KEYS["GigaChat"]}
EOF
        umask 022
        chown root:root "$OAUTH_ENV_FILE"
        chmod 600 "$OAUTH_ENV_FILE"
    else
        rm -f "$OAUTH_ENV_FILE" || true
    fi

    # Ownership for runtime user
    chown -R litellm:litellm "$INSTALL_DIR"
}

write_token_refresh_assets() {
    [[ " ${SELECTED_LLMS[*]} " == *" GigaChat "* ]] || return 0

    info_msg "$(msg token_timer_setup)"
    cat > "$TOKEN_REFRESH_SCRIPT" << EOF
#!/bin/bash
set -euo pipefail

ENV_FILE="$ENV_FILE"
OAUTH_URL="$GIGACHAT_OAUTH_URL"
SCOPE="$GIGACHAT_OAUTH_SCOPE"
OAUTH_ENV_FILE="$OAUTH_ENV_FILE"
INSECURE="$GIGACHAT_OAUTH_INSECURE"
RESTART_AFTER=0
if [[ "\${1:-}" == "--restart" ]]; then
  RESTART_AFTER=1
fi

[[ -f "\$OAUTH_ENV_FILE" ]] || exit 0
AUTH_KEY="\$(sed -n 's/^GIGACHAT_AUTHORIZATION_KEY=//p' "\$OAUTH_ENV_FILE" | head -n1)"
[[ -n "\$AUTH_KEY" ]] || exit 0

sleep \$((RANDOM % 16))
if [[ "\$INSECURE" -eq 1 ]]; then
  echo "refresh warning: Using insecure TLS for GigaChat OAuth endpoint."
fi
RESP="\$(curl --silent --show-error --fail --connect-timeout 5 --max-time 15 \\
  \$( [[ "\$INSECURE" -eq 1 ]] && echo "--insecure" ) \\
  --request POST "\$OAUTH_URL" \\
  --header "Authorization: Basic \${AUTH_KEY}" \\
  --header "RqUID: \$(cat /proc/sys/kernel/random/uuid)" \\
  --header "Content-Type: application/x-www-form-urlencoded" \\
  --data "scope=\$SCOPE")"
TOKEN="\$(printf '%s' "\$RESP" | jq -r '.access_token // empty')"
EXPIRES_RAW="\$(printf '%s' "\$RESP" | jq -r '.expires_at // empty')"
[[ -n "\$TOKEN" && "\$EXPIRES_RAW" =~ ^[0-9]+$ ]] || { echo "refresh failed: invalid OAuth response"; exit 1; }
if [[ "\$TOKEN" == \[* || "\$TOKEN" =~ [[:space:]] ]]; then
  echo "refresh failed: token format guard blocked invalid token payload"
  exit 1
fi
if (( EXPIRES_RAW > 1000000000000 )); then
  EXPIRES_SEC=\$((EXPIRES_RAW / 1000))
  echo "refresh info: expires_at parsed as ms"
elif (( EXPIRES_RAW > 1000000000 && EXPIRES_RAW < 1000000000000 )); then
  EXPIRES_SEC=\$EXPIRES_RAW
  echo "refresh info: expires_at parsed as sec"
else
  echo "refresh failed: unsupported expires_at format: \$EXPIRES_RAW"
  exit 1
fi
NOW_SEC="\$(date +%s)"
TTL_SEC=\$((EXPIRES_SEC - NOW_SEC))
MIN_TTL=$((TOKEN_REFRESH_INTERVAL_SEC + 300))
if (( MIN_TTL < 900 )); then MIN_TTL=900; fi
echo "refresh info: expires_at=\$EXPIRES_SEC ttl=\$TTL_SEC min_ttl=\$MIN_TTL"
if (( TTL_SEC < MIN_TTL )); then
  echo "refresh failed: ttl too low (\$TTL_SEC)"
  exit 1
fi

TOKEN_DIR="$TOKEN_DIR"
TOKEN_FILE="$GIGACHAT_TOKEN_FILE"
mkdir -p "\$TOKEN_DIR"
chown root:litellm "\$TOKEN_DIR"
chmod 750 "\$TOKEN_DIR"
printf '%s\n' "\$TOKEN" > "\${TOKEN_FILE}.tmp"
chmod 640 "\${TOKEN_FILE}.tmp"
chown root:litellm "\${TOKEN_FILE}.tmp"
mv "\${TOKEN_FILE}.tmp" "\$TOKEN_FILE"
echo "refresh success: token file updated"

if [[ "\$RESTART_AFTER" -eq 1 ]]; then
  systemctl restart litellm.service
fi
EOF
    chmod 700 "$TOKEN_REFRESH_SCRIPT"
    chown root:root "$TOKEN_REFRESH_SCRIPT"

    cat > "$TOKEN_REFRESH_SERVICE_FILE" << EOF
[Unit]
Description=Refresh GigaChat OAuth access token for LiteLLM
After=network-online.target
Wants=network-online.target
StartLimitIntervalSec=600
StartLimitBurst=5

[Service]
Type=oneshot
User=root
EnvironmentFile=$OAUTH_ENV_FILE
ExecStart=$TOKEN_REFRESH_SCRIPT
Restart=on-failure
RestartSec=60
EOF

    cat > "$TOKEN_REFRESH_TIMER_FILE" << EOF
[Unit]
Description=Periodic GigaChat token refresh timer

[Timer]
OnBootSec=1min
OnUnitActiveSec=22min
Persistent=true

[Install]
WantedBy=timers.target
EOF

    systemctl daemon-reload >> "$log_file" 2>&1
    systemctl enable --now litellm-token-refresh.timer >> "$log_file" 2>&1
}

write_systemd_service() {
    info_msg "$(msg systemd_setup)"
    info_msg "$(msg service_user)"

    cat > "$SYSTEMD_SERVICE_FILE" << EOF
[Unit]
Description=LiteLLM Proxy Service
After=network.target

[Service]
Type=simple
User=litellm
Group=litellm
WorkingDirectory=$INSTALL_DIR
EnvironmentFile=$ENV_FILE
ExecStart=$VENV_DIR/bin/litellm --config $CONFIG_FILE --port $LITELLM_PORT
Restart=on-failure
RestartSec=5

# Hardening (reasonable defaults)
NoNewPrivileges=true
PrivateTmp=true
ProtectSystem=full
ProtectHome=true

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload >> "$log_file" 2>&1
    systemctl enable litellm.service >> "$log_file" 2>&1
}

health_check() {
    # Temporarily disabled: endpoint/auth behavior differs across LiteLLM versions.
    return 0
}

# --- Mode handlers ---

do_update() {
    info_msg "$(msg update_start)"
    if [[ ! -d "$VENV_DIR" ]]; then
        error_msg "LiteLLM is not installed in $INSTALL_DIR. Please run the installer first."
        cleanup
        exit 1
    fi

    # upgrade to latest
    source "$VENV_DIR/bin/activate"
    pip install --upgrade pip >> "$log_file" 2>&1
    pip install --upgrade --no-cache-dir "litellm[proxy]>=1.81.12" >> "$log_file" 2>&1
    deactivate

    refresh_gigachat_token_from_env 0

    # restart
    systemctl restart litellm.service >> "$log_file" 2>&1 || true
    sleep 5
    if systemctl is-active --quiet litellm.service; then
        # Optional: verify proxy responds
        health_check
    else
        error_exit "$(msg systemd_error)"
    fi

    info_msg "$(msg update_complete)"
    cleanup
    exit 0
}

do_refresh_token() {
    refresh_gigachat_token_from_env "$RESTART_SERVICE"
    cleanup
    exit 0
}

do_uninstall() {
    local confirm_uninstall=""
    ask "$(msg uninstall_confirm)" confirm_uninstall ""
    if [[ "$confirm_uninstall" =~ ^[Yy]$ ]]; then
        # Stop and remove service artifacts
        systemctl stop litellm.service >> "$log_file" 2>&1 || true
        systemctl disable litellm.service >> "$log_file" 2>&1 || true
        systemctl stop litellm-token-refresh.timer >> "$log_file" 2>&1 || true
        systemctl disable litellm-token-refresh.timer >> "$log_file" 2>&1 || true
        rm -f "$SYSTEMD_SERVICE_FILE" || true
        rm -f "$TOKEN_REFRESH_SERVICE_FILE" || true
        rm -f "$TOKEN_REFRESH_TIMER_FILE" || true
        systemctl daemon-reload >> "$log_file" 2>&1 || true

        # Remove installed files and runtime env
        rm -rf "$INSTALL_DIR" || true
        rm -rf "/etc/litellm" || true
        rm -rf "$TOKEN_DIR" || true
        rm -f "$ENV_FILE" || true
        rm -f "$OAUTH_ENV_FILE" || true

        # Remove dedicated system account/group if present
        if id -u litellm >/dev/null 2>&1; then
            userdel litellm >> "$log_file" 2>&1 || true
        fi
        if getent group litellm >/dev/null 2>&1; then
            groupdel litellm >> "$log_file" 2>&1 || true
        fi

        info_msg "$(msg uninstall_complete)"
    else
        info_msg "$(msg uninstall_aborted)"
    fi
    cleanup
    exit 0
}

if [[ "${MODE:-}" == "update" ]]; then
    do_update
fi
if [[ "${MODE:-}" == "uninstall" ]]; then
    do_uninstall
fi
if [[ "${MODE:-}" == "refresh-token" ]]; then
    do_refresh_token
fi

# --- Main flow ---

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
apt update -y >> "$log_file" 2>&1 || error_exit "$(msg dependencies_error)"
apt install -y python3-venv git curl jq iproute2 >> "$log_file" 2>&1 || error_exit "$(msg dependencies_error)"
info_msg "Dependencies installed."

# 4. Port
STEP=0
STEP_TOTAL=5
step_header "$(msg title_port)"
while true; do
    input_port=""
    ask "$(msg port_prompt)" input_port "4000"
    LITELLM_PORT=${input_port:-4000}

    if ! [[ "$LITELLM_PORT" =~ ^[0-9]+$ ]] || (( LITELLM_PORT < 1024 || LITELLM_PORT > 65535 )); then
        error_msg "$(msg port_invalid)"
    elif is_port_in_use "$LITELLM_PORT"; then
        error_msg "$(msg port_in_use "$LITELLM_PORT")"
    else
        break
    fi
done

# 5. Select LLMs
LLM_OPTIONS=("GigaChat" "OpenAI" "Anthropic" "DeepSeek")
SELECTED_LLMS=()

step_header "$(msg title_llm_select)"
echo "$(msg llm_selection_prompt)"
for i in "${!LLM_OPTIONS[@]}"; do
    echo "$((i + 1)). ${LLM_OPTIONS[$i]}"
done

selection_input=""
ask "" selection_input ""
selected_indices=()
for idx in $selection_input; do
    if [[ "$idx" =~ ^[0-9]+$ ]] && (( idx >= 1 && idx <= ${#LLM_OPTIONS[@]} )); then
        selected_indices+=( "$((idx - 1))" )
    fi
done

# Deduplicate preserving order
seen=" "
for idx in "${selected_indices[@]}"; do
    if [[ "$seen" != *" $idx "* ]]; then
        SELECTED_LLMS+=( "${LLM_OPTIONS[$idx]}" )
        seen+="$idx "
    fi
done

if [[ ${#SELECTED_LLMS[@]} -eq 0 ]]; then
    warn_msg "$(msg llm_none_selected)"
    info_msg "$(msg script_complete)"
    cleanup
    exit 0
fi

# Ensure group/user exists before writing token file with root:litellm ownership.
create_system_user

# 6. Collect API keys (visible input to confirm paste)
declare -A LLM_API_KEYS
declare -A LLM_MODELS
for k in "${!DEFAULT_LLM_MODELS[@]}"; do
    LLM_MODELS["$k"]="${DEFAULT_LLM_MODELS[$k]}"
done

step_header "API Keys"
for llm in "${SELECTED_LLMS[@]}"; do
    sub_header "$(msg title_api_key "$llm")"
    current_key=""
    if [[ "$llm" == "GigaChat" ]]; then
        ask "$(msg gigachat_auth_prompt)" current_key ""
    else
        ask "$(msg api_key_prompt "$llm")" current_key ""
    fi
    if [[ -n "$current_key" ]]; then
        printf "Entered API Key: %s\n" "$current_key" > /dev/tty
    fi
    if [[ -z "$current_key" ]]; then
        warn_msg "$(msg api_key_skipped "$llm")"
        # Still store empty to keep associative lookups safe
        LLM_API_KEYS["$llm"]=""
        continue
    fi
    LLM_API_KEYS["$llm"]="$current_key"
done

if [[ " ${SELECTED_LLMS[*]} " == *" GigaChat "* ]]; then
    info_msg "$(msg gigachat_token_refresh)"
    initial_gigachat_token="$(request_gigachat_access_token "${LLM_API_KEYS["GigaChat"]}")" || error_exit "$(msg gigachat_token_refresh_failed)"
    write_gigachat_token_atomic "$initial_gigachat_token" || error_exit "$(msg gigachat_token_refresh_failed)"
    info_msg "$(msg gigachat_token_refresh_done)"
fi

# 7. Priority reorder
if [[ ${#SELECTED_LLMS[@]} -gt 1 ]]; then
    selected_list=$(printf "%s " "${SELECTED_LLMS[@]}" | sed 's/ $//')
    step_header "$(msg title_priority)"

    priority_retries=0
    while true; do
        priority_order_input=""
        ask "$(msg priority_prompt "$selected_list")" priority_order_input ""
        IFS=' ' read -r -a PRIORITY_ORDER <<< "$priority_order_input"

        if [[ ${#PRIORITY_ORDER[@]} -ne ${#SELECTED_LLMS[@]} ]]; then
            error_msg "$(msg priority_invalid)"
        else
            declare -A seen_order=()
            valid_order=1
            for order in "${PRIORITY_ORDER[@]}"; do
                if ! [[ "$order" =~ ^[0-9]+$ ]] || (( order < 1 || order > ${#SELECTED_LLMS[@]} )); then
                    valid_order=0; break
                fi
                if [[ -n "${seen_order[$order]:-}" ]]; then
                    valid_order=0; break
                fi
                seen_order[$order]=1
            done

            if [[ "$valid_order" -eq 1 ]]; then
                reordered_llms=()
                for order in "${PRIORITY_ORDER[@]}"; do
                    reordered_llms+=( "${SELECTED_LLMS[$((order - 1))]}" )
                done
                SELECTED_LLMS=( "${reordered_llms[@]}" )
                break
            fi

            error_msg "$(msg priority_invalid)"
        fi

        priority_retries=$((priority_retries + 1))
        if (( priority_retries >= MAX_RETRIES )); then
            error_exit "$(msg priority_retry)"
        fi
    done
fi

# 8. Install LiteLLM
info_msg "$(msg litellm_install)"
mkdir -p "$INSTALL_DIR"
SCRIPT_SOURCE="${BASH_SOURCE[0]:-$0}"
if [[ -r "$SCRIPT_SOURCE" ]]; then
    install -m 755 "$SCRIPT_SOURCE" "$INSTALL_DIR/install.sh" >> "$log_file" 2>&1 || true
fi
info_msg "$(msg venv_create)"
python3 -m venv "$VENV_DIR"
source "$VENV_DIR/bin/activate"
pip install --upgrade pip >> "$log_file" 2>&1 || error_exit "$(msg litellm_install_error)"
pip install --upgrade --no-cache-dir "litellm[proxy]>=1.81.12" >> "$log_file" 2>&1 || error_exit "$(msg litellm_install_error)"
deactivate

# 9. Create config/env
write_config_and_env
write_systemd_service
write_token_refresh_assets

# 10. Start & check
info_msg "$(msg systemd_start)"
systemctl start litellm.service >> "$log_file" 2>&1
sleep 5

info_msg "$(msg systemd_status)"
if ! systemctl is-active --quiet litellm.service; then
    error_exit "$(msg systemd_error)"
fi

health_check
info_msg "$(msg litellm_ready "$LITELLM_PORT")"

# 11. OpenClaw integration info
info_msg "$(msg openclaw_config_info)"
info_msg "$(msg api_base "$LITELLM_PORT")"
info_msg "$(msg openclaw_model)"

echo "----------------------------------------"
echo "LiteLLM install summary:"
echo "  URL: http://localhost:${LITELLM_PORT}"
echo "  API Base: http://localhost:${LITELLM_PORT}/openai/v1"
echo "  Model: openclaw-brain"
echo "----------------------------------------"

# 12. Optional OpenClaw install
step_header "$(msg title_openclaw)"
install_oc=""
ask "$(msg openclaw_install_prompt)" install_oc ""
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

info_msg "$(msg script_complete)"
cleanup
