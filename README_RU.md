[English Version](README.md) | Русский

# LiteLLM & OpenClaw Installer (Русская версия)

Этот скрипт предназначен для автоматической установки и настройки [LiteLLM Proxy](https://litellm.ai/) с поддержкой нескольких Large Language Models (LLM), включая GigaChat, OpenAI, Anthropic и DeepSeek, на операционных системах Debian/Ubuntu. После успешной настройки LiteLLM скрипт предлагает опционально запустить официальный инсталлятор [OpenClaw](https://openclaw.ai/) (https://openclaw.ai/install.sh).

LiteLLM будет настроен как системный сервис (`systemd`), что обеспечит его автоматический запуск при старте системы и надежную работу.

### Ресурсы LiteLLM:
*   **Официальный сайт:** [litellm.ai](https://litellm.ai/)
*   **Документация:** [docs.litellm.ai](https://docs.litellm.ai/)
*   **GitHub:** [github.com/BerriAI/litellm](https://github.com/BerriAI/litellm)

## Возможности

*   **Поддержка ОС:** Debian и Ubuntu.
*   **Интерактивный выбор LLM:** Выберите, какие LLM вы хотите использовать:
    *   [GigaChat](https://developers.sber.ru/docs/ru/gigachat/models)
    *   [OpenAI](https://platform.openai.com/docs/models)
    *   [Anthropic](https://docs.anthropic.com/en/docs/about-claude/models/overview)
    *   [DeepSeek](https://platform.deepseek.com/docs)
*   **Ввод учётных данных провайдеров:** Для GigaChat вводится OAuth Authorization Key. Для остальных провайдеров — API-ключи.
*   **Автообновление OAuth токена GigaChat:** `systemd` таймер обновляет `access_token` примерно каждые 22 минуты без регулярных рестартов LiteLLM.
*   **Лимит попыток:** Неверные API-ключи и ввод приоритета ограничены 3 попытками.
*   **Настраиваемый приоритет LLM (Fallback):** Определите порядок использования LLM в случае недоступности основной модели.
*   **Выбор порта LiteLLM:** Укажите желаемый порт для работы LiteLLM Proxy.
*   **Изолированная установка:** LiteLLM устанавливается в виртуальное окружение Python (`venv`).
*   **Автозапуск:** LiteLLM настраивается как `systemd` сервис для автоматического запуска.
*   **Опциональная установка OpenClaw:** После настройки LiteLLM скрипт предложит запустить официальный инсталлятор OpenClaw.
*   **Управление:** Поддержка флагов `--update` для обновления LiteLLM и `--uninstall` для полного удаления (сервис, файлы установки, `/etc/litellm`, системный пользователь/группа `litellm`).

## Установка

Для запуска инсталлятора выполните следующую команду в вашем терминале:

```bash
curl -sSL https://raw.githubusercontent.com/countrvl/litellm_install/main/install.sh | sudo bash
```

### Шаги установки:

1.  **Запуск скрипта:** Выполните команду выше. Скрипт запросит права `sudo`.
2.  **Выбор порта LiteLLM:** Введите желаемый порт для LiteLLM (по умолчанию `4000`).
3.  **Выбор LLM:** Выберите номера LLM, которые вы хотите использовать (например, `1 2 4` для GigaChat, OpenAI и DeepSeek).
4.  **Ввод учётных данных:** Для GigaChat введите OAuth Authorization Key. Для остальных провайдеров введите API-ключи.
5.  **Установка приоритетов:** Если выбрано несколько LLM, скрипт предложит установить порядок их использования (приоритет/fallback). Неверный ввод ограничен 3 попытками.
6.  **Установка OpenClaw (опционально):** После настройки LiteLLM скрипт предложит запустить официальный инсталлятор OpenClaw.


## Использование

После успешной установки LiteLLM будет доступен по адресу `http://localhost:<ВАШ_ПОРТ_LITELLM>`.

### Настройка OpenClaw

Для подключения OpenClaw к вашему LiteLLM Proxy используйте следующие параметры:

*   **API Base:** `http://localhost:<ВАШ_ПОРТ_LITELLM>/openai/v1`
*   **API Key:** по умолчанию не требуется этим установщиком
*   **Model:** `openclaw-brain` (это виртуальная модель, которая использует вашу настроенную цепочку приоритетов)

### GigaChat OAuth + файл токена

TLS note: в текущей версии установщик использует insecure TLS режим (`--insecure`) для OAuth GigaChat в средах с self-signed цепочками. Это снижает защиту от MITM; для production рекомендуется перейти на custom CA verification.

Для GigaChat установщик использует OAuth и хранит runtime-токен в файле:

- runtime env для LiteLLM: `/etc/litellm/litellm.env`
- OAuth env для refresh unit: `/etc/litellm/gigachat.env` (`GIGACHAT_AUTHORIZATION_KEY`)
- access token хранится в `/etc/litellm/tokens/gigachat.token`
- LiteLLM использует `api_key: file:/etc/litellm/tokens/gigachat.token`
- `litellm-token-refresh.timer` обновляет токен каждые ~22 минуты (без регулярных рестартов proxy)
- права:
  - `/etc/litellm/tokens` -> `0750 root:litellm`
  - `/etc/litellm/tokens/gigachat.token` -> `0640 root:litellm`
- refresh fail-safe: при ошибке OAuth/TTL текущий token-файл не перезаписывается

Конфиг генерируется детерминированно:

- выбран только один провайдер -> простой `model_list` без `router_settings`
- для режима only GigaChat дополнительно создаётся alias `gigachat-2`
- выбрано несколько провайдеров -> alias-модели + `router_settings.fallbacks` только на существующие alias

### Обновление LiteLLM

Для обновления LiteLLM до версии 1.81.12 или новее:

```bash
sudo /opt/litellm/install.sh --update
```

### Обновление токена GigaChat

Ручное обновление токена (без рестарта):

```bash
sudo /opt/litellm/install.sh --refresh-token
```

Ручное обновление токена с рестартом LiteLLM:

```bash
sudo /opt/litellm/install.sh --refresh-token --restart-service
```

### Диагностика

```bash
sudo /opt/litellm/venv/bin/pip show litellm | grep -i '^Version'
sudo systemctl status litellm --no-pager
sudo systemctl status litellm-token-refresh.timer --no-pager
sudo systemctl status litellm-token-refresh.service --no-pager
sudo journalctl -u litellm-token-refresh.service -n 100 --no-pager
sudo ls -l /etc/litellm/tokens/gigachat.token
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
- системного пользователя `litellm` и группу `litellm` (если существуют)

## Поддерживаемые LLM

*   **[GigaChat](https://developers.sber.ru/docs/ru/gigachat/models):** `gigachat/GigaChat-2`
*   **[OpenAI (GPT-5-nano)](https://platform.openai.com/docs/models):** `openai/gpt-5-nano`
*   **[Anthropic (Haiku 4.5)](https://docs.anthropic.com/en/docs/about-claude/models/overview):** `anthropic/claude-haiku-4-5`
*   **[DeepSeek (deepseek-chat)](https://platform.deepseek.com/docs):** `deepseek/deepseek-chat`

## Лицензия

Этот проект распространяется под лицензией MIT. См. файл [LICENSE](LICENSE) для получения дополнительной информации.
