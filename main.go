package main

import (
	"fmt"
	"github.com/pronuntio/core/configuration"
)

func main() {
	appConf := confguration.ParseArgs()

	fmt.Println("args:", appConf)
	fmt.Println("works")
}
