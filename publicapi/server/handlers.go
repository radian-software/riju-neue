package server

import (
	"net/http"

	"github.com/gorilla/mux"
	"github.com/prometheus/client_golang/prometheus/promhttp"
)

type server struct {
	//
}

func (s *server) handleHealthCheck(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(http.StatusOK)
}

func (s *server) getMainHandler() http.Handler {
	r := mux.NewRouter()
	return r
}

func (s *server) getMetricsHandler() http.Handler {
	r := mux.NewRouter()
	r.HandleFunc("/readiness", s.handleHealthCheck).Methods("GET")
	r.HandleFunc("/liveness", s.handleHealthCheck).Methods("GET")
	r.Handle("/metrics", promhttp.Handler()).Methods("GET")
	return r
}
