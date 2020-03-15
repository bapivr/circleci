name: Node CI

on: [push]

jobs:
  build:

    runs-on: ubuntu-latest
    strategy:    # run a matrix strategy
      matrix:
        node-version: [12.x]

    steps:
    - uses: actions/checkout@v1
    - name: Use Node.js ${{ matrix.node-version }}
      uses: actions/setup-node@v1
      with:
        node-version: ${{ matrix.node-version }}
    - name: npm install, build, and test
      run: |
        npm install
        npm run build --if-present
        npm test
    - name: Build Container Image
      run: |
        docker build -t expressimage .
    - name: push to dockerhub  # mmm
      uses = "actions/docker/login@master"
      secrets = ["DOCKER_USERNAME", "DOCKER_PASSWORD"]
      run: docker push bapivr\expressimage
      env:
        CI: true