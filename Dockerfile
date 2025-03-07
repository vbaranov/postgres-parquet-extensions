FROM postgres:15-bullseye

COPY install-parquet-extension-deps.sh install-parquet-extension-deps.sh
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git

RUN chmod +x ./install-parquet-extension-deps.sh
RUN ./install-parquet-extension-deps.sh

# Get Rust
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y

# Add .cargo/bin to PATH
ENV PATH="/root/.cargo/bin:${PATH}"

# Build parquet_fdw Postgres extension
RUN git clone https://github.com/adjust/parquet_fdw && cd /parquet_fdw && make install

ARG BLOCKSCOUT_USER=blockscout
ARG BLOCKSCOUT_GROUP=blockscout
ARG BLOCKSCOUT_UID=10001
ARG BLOCKSCOUT_GID=10001

RUN addgroup --system --gid ${BLOCKSCOUT_GID} ${BLOCKSCOUT_GROUP} && \
    adduser --system --uid ${BLOCKSCOUT_UID} --ingroup ${BLOCKSCOUT_GROUP} --disabled-password ${BLOCKSCOUT_USER}

RUN chown -R ${BLOCKSCOUT_USER}:${BLOCKSCOUT_GROUP} /var/lib/postgresql/data
RUN chown -R ${BLOCKSCOUT_USER}:${BLOCKSCOUT_GROUP} /usr/lib/postgresql/15/lib
RUN chown -R ${BLOCKSCOUT_USER}:${BLOCKSCOUT_GROUP} /usr/share/postgresql/15/extension

USER ${BLOCKSCOUT_USER}:${BLOCKSCOUT_GROUP}

# Get Rust
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y

# Add .cargo/bin to PATH
ENV PATH="/home/blockscout/.cargo/bin:${PATH}"

WORKDIR /home/blockscout
RUN cd /home/blockscout

# Build pg_parquet Postgres extension
RUN git clone https://github.com/CrunchyData/pg_parquet && \
    cd /home/blockscout/pg_parquet && \
    cargo install cargo-pgrx@0.13.1 && \
    cargo pgrx init --pg15 $(which pg_config) && \
    echo "shared_preload_libraries = 'pg_parquet'" >> ~/.pgrx/data-15/postgresql.conf && \
    cargo pgrx run pg15