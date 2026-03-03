English | [Русский](README_RU.md)

# LiteLLM & OpenClaw Installer

This script automates the installation and configuration of [LiteLLM Proxy](https://litellm.ai/) with support for multiple Large Language Models (LLM), including GigaChat, OpenAI, Anthropic, and DeepSeek, on Debian/Ubuntu operating systems. After successfully setting up LiteLLM, the script optionally offers to run the official [OpenClaw](https://openclaw.ai/) installer (https://openclaw.ai/install.sh).

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
*   **Provider Credentials Input:** For GigaChat, enter OAuth Authorization Key. For other providers, enter API keys.
*   **Automatic GigaChat OAuth Token Refresh:** A `systemd` timer refreshes GigaChat `access_token` every ~22 minutes without regular LiteLLM restarts.
*   **Retry Limits:** Invalid API keys and priority input are limited to 3 attempts.
*   **Configurable LLM Priority (Fallback):** Define the order of LLM usage in case the primary model is unavailable.
*   **LiteLLM Port Selection:** Specify the desired port for the LiteLLM Proxy.
*   **Isolated Installation:** LiteLLM is installed in a Python virtual environment (`venv`).
*   **Autostart:** LiteLLM is configured as a `systemd` service for automatic startup.
*   **Optional OpenClaw Installation:** After LiteLLM setup, the script will offer to run the official OpenClaw installer.
*   **Management:** Supports `--update` flag for LiteLLM updates and `--uninstall` for complete removal (service, installation files, `/etc/litellm`, system user/group `litellm`).

## Installation

To run the installer, execute the following command in your terminal:

```bash
curl -sSL https://raw.githubusercontent.com/countrvl/litellm_install/main/install.sh | sudo bash
```

### Installation Steps:

1.  **Run the script:** Execute the command above. The script will request `sudo` privileges.
2.  **LiteLLM Port Selection:** Enter the desired port for LiteLLM (default `4000`).
3.  **LLM Selection:** Choose the numbers of the LLMs you want to use (e.g., `1 2 4` for GigaChat, OpenAI, and DeepSeek).
4.  **Credentials Entry:** For GigaChat, enter OAuth Authorization Key. For other providers, enter API keys.
5.  **Set Priorities:** If multiple LLMs are selected, the script will ask you to set their usage order (priority/fallback). Invalid input is limited to 3 attempts.
6.  **OpenClaw Installation (optional):** After LiteLLM setup, the script will offer to run the official OpenClaw installer.


## Usage

After successful installation, LiteLLM will be accessible at `http://localhost:<YOUR_LITELLM_PORT>`.

### OpenClaw Configuration

To connect OpenClaw to your LiteLLM Proxy, use the following parameters:

*   **API Base:** `http://localhost:<YOUR_LITELLM_PORT>/openai/v1`
*   **API Key:** not required by this installer by default
*   **Model:** `openclaw-brain` (this is a virtual model that uses your configured priority chain)

### GigaChat OAuth + File Token

TLS note: this installer currently uses insecure TLS mode (`--insecure`) for GigaChat OAuth to support environments with self-signed certificate chains. This reduces MITM protection; migrate to custom CA verification for production.

For GigaChat, the installer uses OAuth and stores runtime token in a file:

- runtime env for LiteLLM: `/etc/litellm/litellm.env`
- OAuth env for refresh unit: `/etc/litellm/gigachat.env` (`GIGACHAT_AUTHORIZATION_KEY`)
- access token is stored in `/etc/litellm/tokens/gigachat.token`
- LiteLLM uses `api_key: file:/etc/litellm/tokens/gigachat.token`
- `litellm-token-refresh.timer` refreshes token every ~22 minutes (no regular proxy restarts)
- permissions:
  - `/etc/litellm/tokens` -> `0750 root:litellm`
  - `/etc/litellm/tokens/gigachat.token` -> `0640 root:litellm`
- refresh is fail-safe: on OAuth/TTL failure current token file is preserved

Config generation is deterministic:

- only one provider selected -> simple `model_list` without `router_settings`
- only GigaChat additionally exposes alias `gigachat-2`
- multi-provider selected -> aliases + `router_settings.fallbacks` only for existing aliases

### Update LiteLLM

To update LiteLLM to version 1.81.12 or newer:

```bash
sudo /opt/litellm/install.sh --update
```

### Refresh GigaChat Token

Manual token refresh (no restart):

```bash
sudo /opt/litellm/install.sh --refresh-token
```

Manual token refresh with LiteLLM restart:

```bash
sudo /opt/litellm/install.sh --refresh-token --restart-service
```

### Diagnostics

```bash
sudo /opt/litellm/venv/bin/pip show litellm | grep -i '^Version'
sudo systemctl status litellm --no-pager
sudo systemctl status litellm-token-refresh.timer --no-pager
sudo systemctl status litellm-token-refresh.service --no-pager
sudo journalctl -u litellm-token-refresh.service -n 100 --no-pager
sudo ls -l /etc/litellm/tokens/gigachat.token
```

### Uninstall LiteLLM

To completely remove LiteLLM and all its components:

```bash
sudo /opt/litellm/install.sh --uninstall
```

`--uninstall` removes:
- `litellm.service` (`systemd` stop/disable + unit file removal)
- `/opt/litellm`
- `/etc/litellm` (including `litellm.env`)
- system user `litellm` and group `litellm` (if present)

## Supported LLMs

*   **[GigaChat](https://developers.sber.ru/docs/ru/gigachat/models):** `gigachat/GigaChat-2`
*   **[OpenAI (GPT-5-nano)](https://platform.openai.com/docs/models):** `openai/gpt-5-nano`
*   **[Anthropic (Haiku 4.5)](https://docs.anthropic.com/en/docs/about-claude/models/overview):** `anthropic/claude-haiku-4-5`
*   **[DeepSeek (deepseek-chat)](https://platform.deepseek.com/docs):** `deepseek/deepseek-chat`

## License

This project is distributed under the MIT License. See the [LICENSE](LICENSE) file for more information.
