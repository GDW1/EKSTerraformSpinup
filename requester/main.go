package main

import (
	"fmt"
	"context"
	"log"
	"net/http"
	"io/ioutil"
	//"github.com/ghodss/yaml"
	"github.com/ericchiang/k8s"
    corev1 "github.com/ericchiang/k8s/apis/core/v1"
)

func main(){
	http.HandleFunc("/", func (w http.ResponseWriter, r *http.Request) {
		setupResponse(&w, r)
		if (*r).Method == "OPTIONS" {
			return
		}	
		resp, _ := http.Get("http://10.0.1.53:80")
		w.WriteHeader(200)
		body, err := ioutil.ReadAll(resp.Body)
		if err != nil {
			panic(err)
		}
		fmt.Fprint(w, string(body))
	})
	http.ListenAndServe(":80", nil)
}

func getIP() string{
	client, err := k8s.NewInClusterClient()
	if err != nil {
		log.Fatal(err)
	}

	var endpoints corev1.Endpoints
	if err := client.Get(context.Background(), "backend", "hello", &endpoints); err != nil {
		log.Fatal(err)
	}
	callable := "http://" + (*endpoints.Subsets[0].Addresses[0].Ip)
	return callable
}

func setupResponse(w *http.ResponseWriter, req *http.Request) {
	(*w).Header().Set("Access-Control-Allow-Origin", "*")
    (*w).Header().Set("Access-Control-Allow-Methods", "POST, GET, OPTIONS, PUT, DELETE")
    (*w).Header().Set("Access-Control-Allow-Headers", "Accept, Content-Type, Content-Length, Accept-Encoding, X-CSRF-Token, Authorization")
}
