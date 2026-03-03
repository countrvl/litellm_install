English | [Русский](README_RU.md)

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
