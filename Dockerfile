FROM frolvlad/alpine-java:jdk8-full

# MAINTAINER Autor <henrique.schmidt@4all.com>

# export android version variables  
ENV ANDROID_COMPILE_SDK="29"
ENV ANDROID_BUILD_TOOLS="29.0.2"
ENV ANDROID_SDK_TOOLS="r29.0.2-linux"

# export variables
ENV ANDROID_HOME="/usr/local/android-sdk/"
ENV PATH="$PATH:/usr/local/android-sdk/platform-tools/"
ENV PATH="~/.local/bin:$PATH"

# run
RUN apk update && \
    # install deps
    apk add --no-cache bash gcc curl unzip libstdc++ libusb musl zlib libgcc python3  && \
    # download android sdk
    curl https://dl.google.com/android/repository/build-tools_${ANDROID_SDK_TOOLS}.zip -o android-sdk.zip && \
    unzip android-sdk.zip -d /usr/local/android-sdk && \
    rm ./android-sdk.zip && \
    # create android licenses
    mkdir "$ANDROID_HOME/licenses" && \
    echo "601085b94cd77f0b54ff86406957099ebe79c4d6" >> "$ANDROID_HOME/licenses/android-googletv-license" && \
    echo "d56f5187479451eabf01fb78af6dfcb131a6481e" >> "$ANDROID_HOME/licenses/android-sdk-license" && \
    echo "84831b9409646a918e30573bab4c9c91346d8abd" >> "$ANDROID_HOME/licenses/android-sdk-preview-license" && \
    echo "33b6a2b64607f11b759f320ef9dff4ae5c47d97a" >> "$ANDROID_HOME/licenses/google-gdk-license" && \
    echo "e9acab5b5fbb560a72cfaecce8946896ff6aab9d" >> "$ANDROID_HOME/licenses/mips-android-sysimage-license" && \
    # download build-tools
    /usr/local/android-sdk/tools/bin/sdkmanager --update && \
    echo y | /usr/local/android-sdk/tools/bin/sdkmanager "platforms;android-${ANDROID_COMPILE_SDK}" "build-tools;${ANDROID_BUILD_TOOLS}" "extras;google;m2repository" "extras;android;m2repository"  && \
    chmod 777 -R /usr/local/android-sdk/ && \
    # download aws tools
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python3 get-pip.py && \
    rm get-pip.py && \
    pip install --upgrade pip && \
    pip install awscli --upgrade && \
    # clean deps
    apk del unzip && \
    # install ktlint
    curl https://github.com/shyiko/ktlint/releases/download/0.33.0/ktlint  -o ./ktlint && \
    chmod +x ./ktlint \
    # install node
    curl "https://nodejs.org/dist/latest/node-${VERSION:-$(wget -qO- https://nodejs.org/dist/latest/ | sed -nE 's|.*>node-(.*)\.pkg</a>.*|\1|p')}.pkg" > "$HOME/Downloads/node-latest.pkg" && sudo installer -store -pkg "$HOME/Downloads/node-latest.pkg" -target "/"

