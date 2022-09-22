FROM rust:1.63.0 as planner

WORKDIR /app

RUN cargo install cargo-chef

COPY . .

RUN cargo chef prepare --recipe-path recipe.json

FROM rust:1.63.0 as cacher

WORKDIR /app

RUN cargo install cargo-chef

COPY --from=planner /app/recipe.json recipe.json

RUN cargo chef cook --release --recipe-path recipe.json

FROM rust:1.63.0 as builder

COPY . /app

WORKDIR /app

COPY --from=cacher /app/target target

COPY --from=cacher /usr/local/cargo /usr/local/cargo

RUN cargo build --release

FROM gcr.io/distroless/cc-debian11

COPY --from=builder /app/target/release/echo /app/echo

WORKDIR /app

CMD ["./echo"]