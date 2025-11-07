# Base image: lightweight Ubuntu
FROM ubuntu:22.04

# Switch to root to install packages
USER root

# Avoid prompts during install
ENV DEBIAN_FRONTEND=noninteractive

# Install essential dev tools
RUN apt-get update && apt-get install -y \
    curl \
    git \
    wget \
    unzip \
    xz-utils \
    libglu1-mesa \
    fish \
    build-essential \
    openssh-client \
    ca-certificates \
    fonts-droid-fallback \
    nala \
    libgtk-3-dev \
    mesa-utils \
    libgl1-mesa-dev \
    gnupg2 \
    apt-transport-https \
    openjdk-17-jdk \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Google Chrome
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor > /usr/share/keyrings/google.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update && apt-get install -y google-chrome-stable && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Add Fish shell to valid shells
RUN echo /usr/bin/fish >> /etc/shells

# Install Sudo 
RUN apt-get update && apt-get install -y sudo \
    && usermod -aG sudo $USERNAME

# Create a non-root developer user (codespace user)
ARG USERNAME=codespace
ARG UID=1000
ARG GID=1000
RUN groupadd -g $GID $USERNAME \
    && useradd -m -u $UID -g $GID -s /usr/bin/fish $USERNAME \
    && chown -R $USERNAME:$USERNAME /home/$USERNAME

USER $USERNAME
WORKDIR /workspace

# Install Flutter
ENV FLUTTER_HOME=/home/$USERNAME/flutter
RUN git clone https://github.com/flutter/flutter.git -b stable $FLUTTER_HOME
ENV PATH="$FLUTTER_HOME/bin:/usr/lib/jvm/java-17-openjdk-amd64/bin:$PATH"
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV TAR_OPTIONS=--no-same-owner

# Flutter setup
RUN flutter precache && \
    flutter config --enable-web && \
    flutter config --enable-linux-desktop && \
    flutter config --enable-windows-desktop

# Android SDK setup
ENV ANDROID_HOME=/home/$USERNAME/android-sdk
ENV PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator
RUN mkdir -p $ANDROID_HOME/cmdline-tools && \
    curl -Lo sdk.zip https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip && \
    unzip sdk.zip -d $ANDROID_HOME/cmdline-tools && \
    mv $ANDROID_HOME/cmdline-tools/cmdline-tools $ANDROID_HOME/cmdline-tools/latest && \
    rm sdk.zip && \
    yes | sdkmanager --licenses && \
    sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"

# Accept Flutter licenses
RUN yes | flutter doctor --android-licenses

# Default workspace
WORKDIR /workspace/girimote

# Default shell
CMD ["/usr/bin/fish"]
