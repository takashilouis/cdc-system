#!/bin/bash

cd migrate
go get
go run main.go tables.go init
go run main.go tables.go 25012024_posts.go migrate