# Keyboard Backlit Adjust

This repository contains a Bash script that automatically adjusts the keyboard backlight in real time based on the monitor brightness in an inverse manner. In other words, the brighter your monitor, the lower the keyboard backlight will be—and vice versa. All transitions are performed smoothly.

> **Note:**  
> This script was developed and tested exclusively on a MacBook Air (2012). It may require adjustments to work with different hardware.

## Requirements

- **Ubuntu** (or an Ubuntu-based distribution) with a graphical environment.
- **brightnessctl**  
  Install with:
  ```bash
  sudo apt update
  sudo apt install brightnessctl
  ```
- **Bash** (usually already installed)
- **xprintidle** (if you later decide to expand functionality requiring idle detection)  
  Install with:
  ```bash
  sudo apt install xprintidle
  ```

## Description

The script uses `brightnessctl` to:

1. Read the current and maximum brightness of your monitor (using the device `acpi_video0`).
2. Calculate a target keyboard backlight brightness (using the device `smc::kbd_backlight`) as the inverse of the monitor brightness.
3. Perform a smooth transition from the current keyboard brightness to the target value by dividing the difference into small incremental steps.

## Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/keyboard-backlit-adjust.git
   cd keyboard-backlit-adjust
   ```
2. **Make the script executable:**
   ```bash
   chmod +x keyboard_backlit_adjust.sh
   ```

## Usage

To run the script manually, open a terminal in your session and execute:
```bash
./keyboard_backlit_adjust.sh
```
The script will run continuously, adjusting the keyboard brightness in real time based on the monitor brightness.

## Running on Ubuntu Startup

You can configure the script to run automatically on startup. Here are two common methods:

### Method 1 – Using Startup Applications

1. Open the **Startup Applications** program (or **Aplicativos na Inicialização**).
2. Click **Add**.
3. Fill in the fields as follows:
   - **Name:** Keyboard Backlit Adjust
   - **Command:** Provide the full path to the script, e.g.,
     ```
     /home/yourusername/keyboard-backlit-adjust/keyboard_backlit_adjust.sh
     ```
   - **Comment:** Automatically adjusts the keyboard backlight inversely to the monitor brightness.
4. Save your entry.
5. Restart your session (or reboot) to have the script start automatically.

### Method 2 – Using Crontab with @reboot

1. Open a terminal.
2. Edit your crontab by running:
   ```bash
   crontab -e
   ```
3. Add the following line (replace with the full path to your script):
   ```
   @reboot /home/yourusername/keyboard-backlit-adjust/keyboard_backlit_adjust.sh
   ```
4. Save and exit the editor.
5. Reboot your system to test the automatic run.

## Customization

The script variables can be adjusted directly in the file:

- **MAIN_INTERVAL:** The interval (in seconds) for checking brightness changes.
- **MIN_KEYBOARD_BRIGHTNESS** and **MAX_KEYBOARD_BRIGHTNESS:** Define the minimum and maximum brightness values for the keyboard.
- **TRANSITION_SLEEP:** The delay between incremental brightness adjustments for smooth transitions.

Feel free to modify these according to your preferences.

## Contributing

Contributions are welcome! If you have ideas for improvements or bug fixes, please fork the repository and submit a pull request. You can also open issues for suggestions or problems you encounter.

## License

This project is licensed under the [MIT License](LICENSE).
```

Simply update the repository URL and the file paths as needed. This `README.md` provides all the necessary information on what to install, how to run the code manually, and how to set it up to run on Ubuntu startup along with our development environment disclaimer.