FROM crystallang/crystal:latest
WORKDIR /app
COPY . .
RUN shards install
ENTRYPOINT ["crystal", "run", "src/github_analyzer.cr", "--"]
CMD [] 