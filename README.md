[English](#english) | [Русский](#russian)

# English

# LiteLLM & OpenClaw Installer

This script automates the installation and configuration of [LiteLLM Proxy](https://litellm.ai/) with support for multiple Large Language Models (LLM), including GigaChat, OpenAI, Anthropic, and DeepSeek, on Debian/Ubuntu operating systems. After successfully setting up LiteLLM, the script optionally offers to run the official [OpenClaw](https://openclaw.ai/) installer.

LiteLLM will be configured as a `systemd` service, ensuring its automatic startup and reliable operation.

### LiteLLM Resources:
*   **Official Website:** [litellm.ai](https://litellm.ai/)
*   **Documentation:** [docs.litellm.ai](https://docs.litellm.ai/)
*   **GitHub:** [github.com/BerriAI/litellm](https://github.com/BerriAI/litellm)

## Features

*   **OS Support:** Debian and Ubuntu.
*   **Interactive LLM Selection:** Choose which LLMs you want to use:
    *   [GigaChat](https://developers.sber.ru/docs/ru/gigachat/models)
    *   [OpenAI](https://platform.openai.com/docs/models)
    *   [Anthropic](https://docs.anthropic.com/en/docs/about-claude/models/overview)
    *   [DeepSeek](https://platform.deepseek.com/docs)
*   **API Key Validation:** The script validates entered API keys immediately after input.
*   **Configurable LLM Priority (Fallback):** Define the order of LLM usage in case the primary model is unavailable.
*   **LiteLLM Port Selection:** Specify the desired port for the LiteLLM Proxy.
*   **Automatic Master Key Generation:** If not provided, the LiteLLM master key will be automatically generated.
*   **Isolated Installation:** LiteLLM is installed in a Python virtual environment (`venv`).
*   **Autostart:** LiteLLM is configured as a `systemd` service for automatic startup.
*   **Optional OpenClaw Installation:** After LiteLLM setup, the script will offer to run the official OpenClaw installer.
*   **Management:** Supports `--update` flag for LiteLLM updates and `--uninstall` for complete removal.

## Installation

To run the installer, execute the following command in your terminal:

```bash
curl -sSL https://raw.githubusercontent.com/countrvl/litellm_install/main/install.sh | sudo bash
```

### Installation Steps:

1.  **Run the script:** Execute the command above. The script will request `sudo` privileges.
2.  **LiteLLM Port Selection:** Enter the desired port for LiteLLM (default `4000`).
3.  **LiteLLM Master Key:** Enter the LiteLLM master key or press Enter for automatic generation.
4.  **LLM Selection:** Choose the numbers of the LLMs you want to use (e.g., `1 2 4` for GigaChat, OpenAI, and DeepSeek).
5.  **API Key Entry:** For each selected LLM, the script will prompt for the corresponding API keys and validate them.
6.  **Set Priorities:** If multiple LLMs are selected, the script will ask you to set their usage order (priority/fallback).
7.  **OpenClaw Installation (optional):** After LiteLLM setup, the script will offer to run the official OpenClaw installer.

## Usage

After successful installation, LiteLLM will be accessible at `http://localhost:<YOUR_LITELLM_PORT>`.

### OpenClaw Configuration

To connect OpenClaw to your LiteLLM Proxy, use the following parameters:

*   **API Base:** `http://localhost:<YOUR_LITELLM_PORT>/openai/v1`
*   **API Key:** `<YOUR_LITELLM_MASTER_KEY>`
*   **Model:** `openclaw-brain` (this is a virtual model that uses your configured priority chain)

### Update LiteLLM

To update LiteLLM to the latest version:

```bash
sudo /opt/litellm/install.sh --update
```

### Uninstall LiteLLM

To completely remove LiteLLM and all its components:

```bash
sudo /opt/litellm/install.sh --uninstall
```

## Supported LLMs

*   **[GigaChat (Lite)](https://developers.sber.ru/docs/ru/gigachat/models):** `gigachat/GigaChat-2`
*   **[OpenAI (GPT-5-nano)](https://platform.openai.com/docs/models):** `openai/gpt-5-nano`
*   **[Anthropic (Haiku 4.5)](https://docs.anthropic.com/en/docs/about-claude/models/overview):** `anthropic/claude-haiku-4-5`
*   **[DeepSeek (deepseek-chat)](https://platform.deepseek.com/docs):** `deepseek/deepseek-chat`

## License

This project is distributed under the MIT License. See the [LICENSE](LICENSE) file for more information.

---

# Русский

# LiteLLM & OpenClaw Installer (Русская версия)

Этот скрипт предназначен для автоматической установки и настройки [LiteLLM Proxy](https://litellm.ai/) с поддержкой нескольких Large Language Models (LLM), включая GigaChat, OpenAI, Anthropic и DeepSeek, на операционных системах Debian/Ubuntu. После успешной настройки LiteLLM скрипт предлагает опционально запустить официальный инсталлятор [OpenClaw](https://openclaw.ai/).

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
*   **Валидация API-ключей:** Скрипт проверяет введенные API-ключи на валидность сразу после ввода.
*   **Настраиваемый приоритет LLM (Fallback):** Определите порядок использования LLM в случае недоступности основной модели.
*   **Выбор порта LiteLLM:** Укажите желаемый порт для работы LiteLLM Proxy.
*   **Автоматическая генерация Master Key:** Если не указан, мастер-ключ для LiteLLM будет сгенерирован автоматически.
*   **Изолированная установка:** LiteLLM устанавливается в виртуальное окружение Python (`venv`).
*   **Автозапуск:** LiteLLM настраивается как `systemd` сервис для автоматического запуска.
*   **Опциональная установка OpenClaw:** После настройки LiteLLM скрипт предложит запустить официальный инсталлятор OpenClaw.
*   **Управление:** Поддержка флагов `--update` для обновления LiteLLM и `--uninstall` для полного удаления.

## Установка

Для запуска инсталлятора выполните следующую команду в вашем терминале:

```bash
curl -sSL https://raw.githubusercontent.com/countrvl/litellm_install/main/install.sh | sudo bash
```

### Шаги установки:

1.  **Запуск скрипта:** Выполните команду выше. Скрипт запросит права `sudo`.
2.  **Выбор порта LiteLLM:** Введите желаемый порт для LiteLLM (по умолчанию `4000`).
3.  **Мастер-ключ LiteLLM:** Введите мастер-ключ для LiteLLM или нажмите Enter для автоматической генерации.
4.  **Выбор LLM:** Выберите номера LLM, которые вы хотите использовать (например, `1 2 4` для GigaChat, OpenAI и DeepSeek).
5.  **Ввод API-ключей:** Для каждой выбранной LLM скрипт запросит соответствующие API-ключи и проверит их валидность.
6.  **Установка приоритетов:** Если выбрано несколько LLM, скрипт предложит установить порядок их использования (приоритет/fallback).
7.  **Установка OpenClaw (опционально):** После настройки LiteLLM скрипт предложит запустить официальный инсталлятор OpenClaw.

## Использование

После успешной установки LiteLLM будет доступен по адресу `http://localhost:<ВАШ_ПОРТ_LITELLM>`.

### Настройка OpenClaw

Для подключения OpenClaw к вашему LiteLLM Proxy используйте следующие параметры:

*   **API Base:** `http://localhost:<ВАШ_ПОРТ_LITELLM>/openai/v1`
*   **API Key:** `<ВАШ_МАСТЕР_КЛЮЧ_LITELLM>`
*   **Model:** `openclaw-brain` (это виртуальная модель, которая использует вашу настроенную цепочку приоритетов)

### Обновление LiteLLM

Для обновления LiteLLM до последней версии:

```bash
sudo /opt/litellm/install.sh --update
```

### Удаление LiteLLM

Для полного удаления LiteLLM и всех его компонентов:

```bash
sudo /opt/litellm/install.sh --uninstall
```

## Поддерживаемые LLM

*   **[GigaChat (Lite)](https://developers.sber.ru/docs/ru/gigachat/models):** `gigachat/GigaChat-2`
*   **[OpenAI (GPT-5-nano)](https://platform.openai.com/docs/models):** `openai/gpt-5-nano`
*   **[Anthropic (Haiku 4.5)](https://docs.anthropic.com/en/docs/about-claude/models/overview):** `anthropic/claude-haiku-4-5`
*   **[DeepSeek (deepseek-chat)](https://platform.deepseek.com/docs):** `deepseek/deepseek-chat`

## Лицензия

Этот проект распространяется под лицензией MIT. См. файл [LICENSE](LICENSE) для получения дополнительной информации.
