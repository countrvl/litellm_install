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
EN_MESSAGES["priority_prompt"]="Enter the priority order (e.g., 1 2 for %s): "
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
EN_MESSAGES["openclaw_model"]="Suggested model: gigachat-2"
EN_MESSAGES["model_hint"]="Suggested model: use one from /openai/v1/models"
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
EN_MESSAGES["gigachat_auth_prompt_plain"]="Enter GigaChat Authorization Key (base64 client_id:client_secret, press Enter to skip): "
EN_MESSAGES["refresh_token_deprecated"]="--refresh-token is deprecated. In OAuth-native mode LiteLLM refreshes GigaChat token automatically."

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
RU_MESSAGES["priority_prompt"]="Введите порядок приоритета (например, 1 2 для %s): "
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
RU_MESSAGES["openclaw_model"]="Рекомендуемая модель: gigachat-2"
RU_MESSAGES["model_hint"]="Рекомендуемая модель: выберите из /openai/v1/models"
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
RU_MESSAGES["gigachat_auth_prompt_plain"]="Введите Authorization Key GigaChat (base64 client_id:client_secret, Enter чтобы пропустить): "
RU_MESSAGES["refresh_token_deprecated"]="--refresh-token устарел. В OAuth-native режиме LiteLLM обновляет GigaChat token автоматически."

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
        --refresh-token|--restart-service)
            error_exit "$(msg refresh_token_deprecated)"
            ;;
    esac
done

if [[ -z "$LANG_ARG" ]]; then
    set_language
fi

# Require root early for management modes to avoid permission-related partial failures
if [[ "${MODE:-}" == "update" || "${MODE:-}" == "uninstall" ]]; then
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
MANAGED_INSTALLER_URL="${MANAGED_INSTALLER_URL:-https://raw.githubusercontent.com/countrvl/litellm_install/dev/install.sh}"

LITELLM_PORT=4000
MAX_RETRIES=3

# Provider models (adjust if you want different defaults)
declare -A DEFAULT_LLM_MODELS
DEFAULT_LLM_MODELS["GigaChat"]="gigachat/GigaChat-2"
DEFAULT_LLM_MODELS["Anthropic"]="anthropic/claude-sonnet-4-5"
DEFAULT_LLM_MODELS["DeepSeek"]="deepseek/deepseek-reasoner"

model_name_to_llm() {
    case "$1" in
        gigachat) echo "GigaChat" ;;
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

persist_management_script() {
    local target="$INSTALL_DIR/install.sh"
    local copied=0
    local candidates=(
        "${BASH_SOURCE[0]:-}"
        "$0"
        "/proc/$$/fd/255"
        "/dev/fd/255"
    )

    for candidate in "${candidates[@]}"; do
        if [[ -n "$candidate" && -r "$candidate" ]]; then
            if install -m 755 "$candidate" "$target" >> "$log_file" 2>&1; then
                copied=1
                break
            fi
        fi
    done

    if [[ "$copied" -eq 0 ]]; then
        # Fallback wrapper for pipe-based execution where script source cannot be copied.
        cat > "$target" << EOF
#!/bin/bash
set -euo pipefail
curl -sSL "$MANAGED_INSTALLER_URL" | bash -s -- "\$@"
EOF
        chmod 755 "$target"
        chown root:root "$target"
        warn_msg "Installer source could not be copied; created wrapper at $target."
    fi
}

cleanup_legacy_gigachat_artifacts() {
    systemctl stop litellm-token-refresh.timer >> "$log_file" 2>&1 || true
    systemctl disable litellm-token-refresh.timer >> "$log_file" 2>&1 || true
    rm -f "$TOKEN_REFRESH_SERVICE_FILE" "$TOKEN_REFRESH_TIMER_FILE" "$TOKEN_REFRESH_SCRIPT" || true
    rm -f "$OAUTH_ENV_FILE" || true
    rm -rf "$TOKEN_DIR" || true
    systemctl daemon-reload >> "$log_file" 2>&1 || true
}

get_env_value() {
    local key="$1"
    local file="$2"
    [[ -f "$file" ]] || return 0
    sed -n "s/^${key}=//p" "$file" | head -n1
}

load_port_from_service_or_default() {
    local port_from_service=""
    if [[ -f "$SYSTEMD_SERVICE_FILE" ]]; then
        port_from_service="$(sed -n 's/.*--port \([0-9]\{2,5\}\).*/\1/p' "$SYSTEMD_SERVICE_FILE" | head -n1)"
    fi
    if [[ "$port_from_service" =~ ^[0-9]+$ ]]; then
        LITELLM_PORT="$port_from_service"
    else
        LITELLM_PORT=4000
    fi
}

load_state_from_env_for_update() {
    [[ -f "$ENV_FILE" ]] || error_exit "Missing $ENV_FILE. Re-run installer."

    SELECTED_LLMS=()
    declare -gA LLM_API_KEYS
    declare -gA LLM_MODELS
    for k in "${!DEFAULT_LLM_MODELS[@]}"; do
        LLM_MODELS["$k"]="${DEFAULT_LLM_MODELS[$k]}"
    done

    local gigachat_creds anthropic_key deepseek_key
    gigachat_creds="$(get_env_value "GIGACHAT_CREDENTIALS" "$ENV_FILE")"
    anthropic_key="$(get_env_value "ANTHROPIC_API_KEY" "$ENV_FILE")"
    deepseek_key="$(get_env_value "DEEPSEEK_API_KEY" "$ENV_FILE")"

    if [[ -n "$gigachat_creds" ]]; then
        SELECTED_LLMS+=("GigaChat")
        LLM_API_KEYS["GigaChat"]="$gigachat_creds"
    fi
    if [[ -n "$anthropic_key" ]]; then
        SELECTED_LLMS+=("Anthropic")
        LLM_API_KEYS["Anthropic"]="$anthropic_key"
    fi
    if [[ -n "$deepseek_key" ]]; then
        SELECTED_LLMS+=("DeepSeek")
        LLM_API_KEYS["DeepSeek"]="$deepseek_key"
    fi

    [[ ${#SELECTED_LLMS[@]} -gt 0 ]] || error_exit "No provider credentials found in $ENV_FILE."
    DEEP_ANTH_PRIORITY="DeepSeek"
    if [[ -f "$CONFIG_FILE" ]]; then
        if grep -qE '^[[:space:]]*-[[:space:]]*claude-(sonnet|haiku):' "$CONFIG_FILE"; then
            DEEP_ANTH_PRIORITY="Anthropic"
        elif grep -qE '^[[:space:]]*-[[:space:]]*deepseek-(reasoner|chat):' "$CONFIG_FILE"; then
            DEEP_ANTH_PRIORITY="DeepSeek"
        fi
    fi
    load_port_from_service_or_default
}

create_system_user() {
    if id -u litellm >/dev/null 2>&1; then
        info_msg "$(msg user_exists)"
        return 0
    fi
    info_msg "$(msg user_create)"
    useradd --system --no-create-home --shell /usr/sbin/nologin litellm
}

migrate_legacy_gigachat_credentials() {
    # Migrate old oauth env into runtime env if needed.
    if [[ -f "$OAUTH_ENV_FILE" && -f "$ENV_FILE" ]] && ! grep -q '^GIGACHAT_CREDENTIALS=' "$ENV_FILE"; then
        local legacy_key=""
        legacy_key="$(sed -n 's/^GIGACHAT_AUTHORIZATION_KEY=//p' "$OAUTH_ENV_FILE" | head -n1)"
        if [[ -n "$legacy_key" ]]; then
            upsert_env_var "$ENV_FILE" "GIGACHAT_CREDENTIALS" "$legacy_key"
        fi
    fi

    # Migrate old file-token api_key references in config to OAuth-native env var.
    if [[ -f "$CONFIG_FILE" ]]; then
        sed -i "s#api_key: file:$GIGACHAT_TOKEN_FILE#api_key: os.environ/GIGACHAT_CREDENTIALS#g" "$CONFIG_FILE"
    fi
}

write_config_and_env() {
    info_msg "$(msg config_generate)"
    mkdir -p "$CONFIG_DIR"

    local providers_for_config=()
    for llm in "${SELECTED_LLMS[@]}"; do
        if [[ -n "${LLM_API_KEYS[$llm]:-}" ]]; then
            providers_for_config+=( "$llm" )
        else
            warn_msg "Skipping $llm: empty credential."
        fi
    done
    [[ ${#providers_for_config[@]} -gt 0 ]] || error_exit "No valid provider credentials were supplied."

    local has_deepseek=0
    local has_anthropic=0
    local has_gigachat=0
    local llm=""
    for llm in "${providers_for_config[@]}"; do
        case "$llm" in
            DeepSeek) has_deepseek=1 ;;
            Anthropic) has_anthropic=1 ;;
            GigaChat) has_gigachat=1 ;;
        esac
    done

    local deep_first=1
    if (( has_deepseek == 1 && has_anthropic == 1 )) && [[ "${DEEP_ANTH_PRIORITY:-DeepSeek}" == "Anthropic" ]]; then
        deep_first=0
    fi

    local ordered_providers=()
    if (( has_deepseek == 1 && has_anthropic == 1 )); then
        if (( deep_first == 1 )); then
            ordered_providers+=( "DeepSeek" "Anthropic" )
        else
            ordered_providers+=( "Anthropic" "DeepSeek" )
        fi
    else
        (( has_deepseek == 1 )) && ordered_providers+=( "DeepSeek" )
        (( has_anthropic == 1 )) && ordered_providers+=( "Anthropic" )
    fi
    (( has_gigachat == 1 )) && ordered_providers+=( "GigaChat" )

    cat > "$CONFIG_FILE" << EOF
model_list:
EOF

    for llm in "${ordered_providers[@]}"; do
        if [[ "$llm" == "DeepSeek" ]]; then
            cat >> "$CONFIG_FILE" << EOF
  - model_name: deepseek-reasoner
    litellm_params:
      model: deepseek/deepseek-reasoner
      api_key: os.environ/DEEPSEEK_API_KEY
      request_timeout: 30

  - model_name: deepseek-chat
    litellm_params:
      model: deepseek/deepseek-chat
      api_key: os.environ/DEEPSEEK_API_KEY
      request_timeout: 30
EOF
        elif [[ "$llm" == "Anthropic" ]]; then
            cat >> "$CONFIG_FILE" << EOF
  - model_name: claude-sonnet
    litellm_params:
      model: anthropic/claude-sonnet-4-5
      api_key: os.environ/ANTHROPIC_API_KEY
      request_timeout: 30

  - model_name: claude-haiku
    litellm_params:
      model: anthropic/claude-haiku-4-5
      api_key: os.environ/ANTHROPIC_API_KEY
      request_timeout: 30
EOF
        elif [[ "$llm" == "GigaChat" ]]; then
            cat >> "$CONFIG_FILE" << EOF
  - model_name: gigachat-2
    litellm_params:
      model: gigachat/GigaChat-2
      api_key: os.environ/GIGACHAT_CREDENTIALS
      ssl_verify: false
      request_timeout: 30
EOF
        fi
    done

    cat >> "$CONFIG_FILE" << EOF

litellm_settings:
  set_verbose: true
  request_timeout: 30

router_settings:
  num_retries: 2
  timeout: 30
EOF

    local provider_count=0
    provider_count=$((has_deepseek + has_anthropic + has_gigachat))
    if (( provider_count >= 2 )); then
        cat >> "$CONFIG_FILE" << EOF
  fallbacks:
EOF
        if (( provider_count == 2 )); then
            if (( has_deepseek == 1 && has_anthropic == 1 )); then
                if (( deep_first == 1 )); then
                    cat >> "$CONFIG_FILE" << EOF
    - deepseek-reasoner:
        - claude-sonnet
    - deepseek-chat:
        - claude-haiku
EOF
                else
                    cat >> "$CONFIG_FILE" << EOF
    - claude-sonnet:
        - deepseek-reasoner
    - claude-haiku:
        - deepseek-chat
EOF
                fi
            elif (( has_deepseek == 1 && has_gigachat == 1 )); then
                cat >> "$CONFIG_FILE" << EOF
    - deepseek-reasoner:
        - gigachat-2
    - deepseek-chat:
        - gigachat-2
EOF
            elif (( has_anthropic == 1 && has_gigachat == 1 )); then
                cat >> "$CONFIG_FILE" << EOF
    - claude-sonnet:
        - gigachat-2
    - claude-haiku:
        - gigachat-2
EOF
            fi
        elif (( provider_count == 3 )); then
            if (( deep_first == 1 )); then
                cat >> "$CONFIG_FILE" << EOF
    - deepseek-reasoner:
        - claude-sonnet
        - gigachat-2
    - deepseek-chat:
        - claude-haiku
        - gigachat-2
EOF
            else
                cat >> "$CONFIG_FILE" << EOF
    - claude-sonnet:
        - deepseek-reasoner
        - gigachat-2
    - claude-haiku:
        - deepseek-chat
        - gigachat-2
EOF
            fi
        fi
    fi

    # Runtime env for LiteLLM (no OAuth authorization key here)
    mkdir -p "$(dirname "$ENV_FILE")"
    umask 077
    cat > "$ENV_FILE" << EOF
$(for llm in "${providers_for_config[@]}"; do
    if [[ "$llm" == "GigaChat" ]]; then
        echo "GIGACHAT_CREDENTIALS=${LLM_API_KEYS[$llm]}"
    else
        echo "${llm^^}_API_KEY=${LLM_API_KEYS[$llm]}"
    fi
done)
EOF
    umask 022
    chown root:root "$ENV_FILE"
    chmod 600 "$ENV_FILE"

    # Ownership for runtime user
    chown -R litellm:litellm "$INSTALL_DIR"
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
    # Intentionally disabled as install gate: model-level checks may trigger upstream rate limits.
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

    # rebuild config/env from current credentials and restart
    migrate_legacy_gigachat_credentials
    load_state_from_env_for_update
    write_config_and_env
    cleanup_legacy_gigachat_artifacts
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
        cleanup_legacy_gigachat_artifacts
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
LLM_OPTIONS=("GigaChat" "Anthropic" "DeepSeek")
SELECTED_LLMS=()
DEEP_ANTH_PRIORITY="DeepSeek"

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

if [[ " ${SELECTED_LLMS[*]} " == *" DeepSeek "* ]] && [[ " ${SELECTED_LLMS[*]} " == *" Anthropic "* ]]; then
    step_header "$(msg title_priority)"
    local_priority_attempts=0
    while true; do
        echo "1. DeepSeek"
        echo "2. Anthropic"
        priority_input=""
        ask "$(msg priority_prompt "DeepSeek, Anthropic")" priority_input "1 2"
        read -r p1 p2 extra <<< "$priority_input"
        if [[ -z "${extra:-}" ]] && [[ -n "${p1:-}" ]] && [[ -n "${p2:-}" ]] && [[ "$p1" =~ ^[12]$ ]] && [[ "$p2" =~ ^[12]$ ]] && [[ "$p1" != "$p2" ]]; then
            if [[ "$p1" == "1" ]]; then
                DEEP_ANTH_PRIORITY="DeepSeek"
            else
                DEEP_ANTH_PRIORITY="Anthropic"
            fi
            break
        fi
        error_msg "$(msg priority_invalid)"
        local_priority_attempts=$((local_priority_attempts + 1))
        if (( local_priority_attempts >= MAX_RETRIES )); then
            error_exit "$(msg priority_retry)"
        fi
    done
fi

# Ensure dedicated runtime account exists before writing config files.
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
        ask "$(msg gigachat_auth_prompt_plain)" current_key ""
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

# 8. Install LiteLLM
info_msg "$(msg litellm_install)"
mkdir -p "$INSTALL_DIR"
persist_management_script
info_msg "$(msg venv_create)"
python3 -m venv "$VENV_DIR"
source "$VENV_DIR/bin/activate"
pip install --upgrade pip >> "$log_file" 2>&1 || error_exit "$(msg litellm_install_error)"
pip install --upgrade --no-cache-dir "litellm[proxy]>=1.81.12" >> "$log_file" 2>&1 || error_exit "$(msg litellm_install_error)"
deactivate

# 9. Create config/env
write_config_and_env
write_systemd_service
cleanup_legacy_gigachat_artifacts

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
if [[ " ${SELECTED_LLMS[*]} " == *" GigaChat "* ]] && [[ -n "${LLM_API_KEYS["GigaChat"]:-}" ]]; then
    info_msg "$(msg openclaw_model)"
else
    info_msg "$(msg model_hint)"
fi

echo "----------------------------------------"
echo "LiteLLM install summary:"
echo "  URL: http://localhost:${LITELLM_PORT}"
echo "  API Base: http://localhost:${LITELLM_PORT}/openai/v1"
if [[ " ${SELECTED_LLMS[*]} " == *" GigaChat "* ]] && [[ -n "${LLM_API_KEYS["GigaChat"]:-}" ]]; then
    echo "  Models: gigachat-2"
else
    echo "  Models: check /openai/v1/models"
fi
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
