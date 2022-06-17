package main

import (
	"log"

	"github.com/caarlos0/env/v6"
	"github.com/radian-software/riju/publicapi/server"
)

type cfg struct {
	MainPort    int    `env:"RIJU_PUBLICAPI_MAIN_PORT" envDefault:"8080"`
	MetricsPort int    `env:"RIJU_PUBLICAPI_METRICS_PORT" envDefault:"8081"`
	Host        string `env:"RIJU_PUBLICAPI_HOST" envDefault:"0.0.0.0"`
}

func main() {
	cfg := cfg{}
	if err := env.Parse(&cfg); err != nil {
		log.Fatal("failed to parse environment variables:", err.Error())
	}
	if err := server.Listen(&server.Options{
		MainPort:    cfg.MainPort,
		MetricsPort: cfg.MetricsPort,
		Host:        cfg.Host,
	}); err != nil {
		log.Fatal(err)
	}
}
