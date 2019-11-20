# CPUの場合
FROM novnc-ssh

# python関係のパッケージインストール
RUN apt-get update
RUN apt-get install -y --no-install-recommends \
            python3.5-dev python3-tk \
 && wget https://bootstrap.pypa.io/get-pip.py \
 && python3 get-pip.py \
 && pip3 install --upgrade pip

# pythonの標準的な数値計算パッケージのインストール
COPY into_container/requirements_basic.txt /ingredients/
RUN pip3 install -r /ingredients/requirements_basic.txt

# ディープラーニングライブラリのインストール
COPY into_container/requirements_dnn.txt /ingredients/
RUN pip3 install -r /ingredients/requirements_dnn.txt

# open ai gymのインストール
RUN apt-get install -y --no-install-recommends \
        unzip libglu1-mesa-dev libgl1-mesa-dev libosmesa6-dev xvfb patchelf ffmpeg
COPY into_container/requirements_gym.txt /ingredients/
RUN pip3 install -r /ingredients/requirements_gym.txt \
 && pip3 uninstall -y pyglet \
 && pip3 install pyglet==1.3.2

# 強化学習関係のインストール
RUN apt-get install -y --fix-missing --no-install-recommends \
        cmake libopenmpi-dev zlib1g-dev \
        python3-opengl libjpeg-dev \
        swig libboost-all-dev libsdl2-dev

COPY into_container/requirements_rl.txt /ingredients/
RUN pip3 install -r /ingredients/requirements_rl.txt

# その他パッケージのインストール
COPY into_container/requirements_other.txt /ingredients/
RUN pip3 install -r /ingredients/requirements_other.txt

# aptの掃除
RUN apt-get clean \
 && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

# ワーキングスペースの作成
WORKDIR /home/user/workspace


