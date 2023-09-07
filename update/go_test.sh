cd $(dirname $0)

cat << _eof > test_go.go
package main

import "fmt"

func main() {
    fmt.Println("Hello, World!")
}
_eof

go run test_go.go
