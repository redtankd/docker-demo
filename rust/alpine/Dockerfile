FROM redtankd/alpine-base

ARG USER_HOME=/root

# install dependecies

RUN apk update && apk upgrade && \
    apk add --no-cache make cmake g++

# install rust

ARG RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup
ARG RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
ARG SOURCE_CRATES_IO=https://mirrors.ustc.edu.cn/crates.io-index

RUN curl https://sh.rustup.rs -sSf | sh -s -- --default-toolchain stable -y
RUN $USER_HOME/.cargo/bin/rustup toolchain install nightly

COPY ./cargo/config $USER_HOME/.cargo/config
RUN sed -i "s%https://mirrors.ustc.edu.cn/crates.io-index%$SOURCE_CRATES_IO%" $USER_HOME/.cargo/config
RUN cat $USER_HOME/.cargo/config

COPY ./config/fish/config.fish $USER_HOME/.config/fish/config.fish.rust
RUN echo >> $USER_HOME/.config/fish/config.fish
RUN cat $USER_HOME/.config/fish/config.fish.rust >> $USER_HOME/.config/fish/config.fish
RUN rm $USER_HOME/.config/fish/config.fish.rust
RUN sed -i "s%https://mirrors.ustc.edu.cn/rust-static%$RUSTUP_DIST_SERVER%" $USER_HOME/.config/fish/config.fish
RUN sed -i "s%https://mirrors.ustc.edu.cn/rust-static/rustup%$RUSTUP_UPDATE_ROOT%" $USER_HOME/.config/fish/config.fish
RUN cat $USER_HOME/.config/fish/config.fish

RUN env