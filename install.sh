#!/bin/bash

# Скрипт для установки LiteLLM с поддержкой GigaChat, OpenAI, Anthropic
# и опциональной установки OpenClaw на Debian/Ubuntu.

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
