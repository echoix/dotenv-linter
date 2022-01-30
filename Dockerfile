FROM messense/rust-musl-cross:x86_64-musl as builder

# RUN apt-get update && apt-get install musl-tools

RUN cargo new dotenv-linter
COPY Cargo.toml ./
COPY src ./src
COPY benches ./benches

RUN apt-get update && apt-get install musl-tools -y && echo 1

RUN cargo build --release
RUN cargo install --target x86_64-unknown-linux-musl --path .

FROM scratch
COPY --from=builder /root/.cargo/bin/dotenv-linter /
ENTRYPOINT ["/dotenv-linter"]
