package server

import (
	"fmt"
	"log"
	"net/http"
)

type Options struct {
	MainPort    int
	MetricsPort int
	Host        string
}

func Listen(opts *Options) error {
	s := &server{}
	mainAddr := fmt.Sprintf("%s:%d", opts.Host, opts.MainPort)
	metricsAddr := fmt.Sprintf("%s:%d", opts.Host, opts.MetricsPort)
	log.Printf("serving API on http://%s", mainAddr)
	go func() {
		log.Printf("serving metrics on http://%s", metricsAddr)
		if err := http.ListenAndServe(metricsAddr, s.getMetricsHandler()); err != nil {
			// Health checks are served from metrics port,
			// so the failure will be detected
			// automatically.
		}
	}()
	return http.ListenAndServe(mainAddr, s.getMainHandler())
}
