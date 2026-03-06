[English Version](README.md) | Русский

# LiteLLM & OpenClaw Installer (Русская версия)

Этот скрипт предназначен для автоматической установки и настройки [LiteLLM Proxy](https://litellm.ai/) с поддержкой нескольких Large Language Models (LLM), включая GigaChat, Anthropic и DeepSeek, на операционных системах Debian/Ubuntu. После успешной настройки LiteLLM скрипт предлагает опционально запустить официальный инсталлятор [OpenClaw](https://openclaw.ai/) (https://openclaw.ai/install.sh).

LiteLLM будет настроен как системный сервис (`systemd`), что обеспечит его автоматический запуск при старте системы и надежную работу.

### Ресурсы LiteLLM:
*   **Официальный сайт:** [litellm.ai](https://litellm.ai/)
*   **Документация:** [docs.litellm.ai](https://docs.litellm.ai/)
*   **GitHub:** [github.com/BerriAI/litellm](https://github.com/BerriAI/litellm)

## Возможности

*   **Поддержка ОС:** Debian и Ubuntu.
*   **Интерактивный выбор LLM:** Выберите, какие LLM вы хотите использовать:
    *   [GigaChat](https://developers.sber.ru/docs/ru/gigachat/models)
    *   [Anthropic](https://docs.anthropic.com/en/docs/about-claude/models/overview)
    *   [DeepSeek](https://platform.deepseek.com/docs)
*   **Ввод учётных данных провайдеров:** Для GigaChat вводится Authorization Key (`base64(client_id:client_secret)`) как `GIGACHAT_CREDENTIALS`. Для остальных провайдеров — API-ключи.
*   **OAuth-native режим для GigaChat:** LiteLLM сам управляет жизненным циклом OAuth токена в `v1.82.x`.
*   **Видимый ввод учётных данных:** Введённые ключи показываются в TTY, чтобы проверить успешный copy/paste.
*   **Явная регистрация моделей и fallback-цепочек:** Генерируются фиксированные alias моделей, `router_settings` и fallback-правила по приоритету.
*   **Выбор порта LiteLLM:** Укажите желаемый порт для работы LiteLLM Proxy.
*   **Изолированная установка:** LiteLLM устанавливается в виртуальное окружение Python (`venv`).
*   **Автозапуск:** LiteLLM настраивается как `systemd` сервис для автоматического запуска.
*   **Опциональная установка OpenClaw:** После настройки LiteLLM скрипт предложит запустить официальный инсталлятор OpenClaw.
*   **Управление:** Поддержка `--update` для обновления LiteLLM и `--uninstall` для полного удаления (сервис, файлы установки, `/etc/litellm`, системный пользователь/группа `litellm`).

## Установка

Для запуска инсталлятора выполните следующую команду в вашем терминале:

```bash
curl -sSL https://raw.githubusercontent.com/countrvl/litellm_install/main/install.sh | sudo bash
```

### Шаги установки:

1.  **Запуск скрипта:** Выполните команду выше. Скрипт запросит права `sudo`.
2.  **Выбор порта LiteLLM:** Введите желаемый порт для LiteLLM (по умолчанию `4000`).
3.  **Выбор LLM:** Выберите номера LLM, которые вы хотите использовать (например, `1 3` для GigaChat и DeepSeek).
4.  **Приоритет DeepSeek/Anthropic:** Если выбраны оба провайдера, задайте их приоритет (`1 2` или `2 1`).
5.  **Ввод учётных данных:** Для GigaChat введите Authorization Key (`base64(client_id:client_secret)`). Для остальных провайдеров введите API-ключи.
6.  **Установка OpenClaw (опционально):** После настройки LiteLLM скрипт предложит запустить официальный инсталлятор OpenClaw.


## Использование

После успешной установки LiteLLM будет доступен по адресу `http://localhost:<ВАШ_ПОРТ_LITELLM>`.

### Настройка OpenClaw

Для подключения OpenClaw к вашему LiteLLM Proxy используйте следующие параметры:

*   **API Base:** `http://localhost:<ВАШ_ПОРТ_LITELLM>/openai/v1`
*   **API Key:** по умолчанию не требуется этим установщиком
*   **Model:** `gigachat-2` (если выбран GigaChat) или любая модель из `GET /openai/v1/models`

### GigaChat OAuth Credentials (по умолчанию)

Для GigaChat установщик использует встроенный LiteLLM режим OAuth credentials:

- `api_key: os.environ/GIGACHAT_CREDENTIALS`
- ожидаемое значение: `GIGACHAT_CREDENTIALS=<base64(client_id:client_secret)>`
- runtime env файл: `/etc/litellm/litellm.env`
- внешний token-файл/таймер не требуется

Эксплуатационное замечание:

- не делайте агрессивный polling `/health` (особенно с коротким интервалом), так как model-level проверки могут повышать нагрузку на OAuth upstream и вызывать `429 Too Many Requests`.
- установщик/обновление не используют `/health` как критерий успеха; готовность определяется активным `systemd` сервисом.

Конфиг генерируется детерминированно:

- модели:
  - GigaChat: `gigachat-2` -> `gigachat/GigaChat-2`
  - DeepSeek: `deepseek-reasoner`, `deepseek-chat`
  - Anthropic: `claude-sonnet`, `claude-haiku`
- всегда добавляются: `litellm_settings`, `router_settings`, `cache`, `cache_config`, `cache_policy`
- fallback-правила:
  - 1 провайдер: fallback отсутствует
  - 2 провайдера: fallback от приоритетного провайдера к резервному
  - 3 провайдера: приоритет между DeepSeek/Anthropic, `gigachat-2` всегда последний fallback для моделей приоритетного провайдера

### Обновление LiteLLM

Для обновления LiteLLM до версии 1.81.12 или новее:

```bash
sudo /opt/litellm/install.sh --update
```

### Диагностика

```bash
sudo /opt/litellm/venv/bin/pip show litellm | grep -i '^Version'
sudo systemctl status litellm --no-pager -l
sudo grep -n "gigachat/GigaChat-2\\|deepseek-reasoner\\|claude-sonnet\\|fallbacks\\|GIGACHAT_CREDENTIALS" /opt/litellm/config/config.yaml
sudo grep -n '^GIGACHAT_CREDENTIALS=' /etc/litellm/litellm.env
curl -sS http://127.0.0.1:4000/openai/v1/models | jq .
curl -sS http://127.0.0.1:4000/openai/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{"model":"gigachat-2","messages":[{"role":"user","content":"ответь одним словом: ок"}],"max_tokens":8,"temperature":0}' | jq .
```

### Удаление LiteLLM

Для полного удаления LiteLLM и всех его компонентов:

```bash
sudo /opt/litellm/install.sh --uninstall
```

Флаг `--uninstall` удаляет:
- `litellm.service` (остановка/отключение в `systemd` и удаление unit-файла)
- `/opt/litellm`
- `/etc/litellm` (включая `litellm.env`)
- legacy refresh-артефакты (`litellm-token-refresh.service`, `litellm-token-refresh.timer`, `/etc/litellm/tokens`, `/etc/litellm/gigachat.env`), если остались
- системного пользователя `litellm` и группу `litellm` (если существуют)

## Поддерживаемые LLM

*   **[GigaChat](https://developers.sber.ru/docs/ru/gigachat/models):** `gigachat/GigaChat-2` (`model_name: gigachat-2`)
*   **[Anthropic](https://docs.anthropic.com/en/docs/about-claude/models/overview):** `anthropic/claude-sonnet-4-5-20250929` (`claude-sonnet`), `anthropic/claude-haiku-4-5-20251001` (`claude-haiku`)
*   **[DeepSeek](https://platform.deepseek.com/docs):** `deepseek/deepseek-reasoner` (`deepseek-reasoner`), `deepseek/deepseek-chat` (`deepseek-chat`)

## Лицензия

Этот проект распространяется под лицензией MIT. См. файл [LICENSE](LICENSE) для получения дополнительной информации.
