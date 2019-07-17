package main

import (
	"context"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"time"

	"github.com/ericchiang/k8s"
	corev1 "github.com/ericchiang/k8s/apis/core/v1"
)

type Endpoint struct {
	APIVersion string `json:"apiVersion"`
	Kind       string `json:"kind"`
	Metadata   struct {
		Annotations struct {
		} `json:"annotations"`
		Name      string `json:"name"`
		Namespace string `json:"namespace"`
	} `json:"metadata"`
	Subsets []struct {
		Addresses []struct {
			IP string `json:"ip"`
		} `json:"addresses"`
		Ports []struct {
			Name string `json:"name"`
			Port int    `json:"port"`
		} `json:"ports"`
	} `json:"subsets"`
}

type Gen struct {
	Metadata struct {
		Name              string    `json:"name"`
		GenerateName      string    `json:"generateName"`
		Namespace         string    `json:"namespace"`
		SelfLink          string    `json:"selfLink"`
		UID               string    `json:"uid"`
		ResourceVersion   string    `json:"resourceVersion"`
		Generation        int       `json:"generation"`
		CreationTimestamp time.Time `json:"creationTimestamp"`
		Annotations       struct {
			KubectlKubernetesIoLastAppliedConfiguration string `json:"kubectl.kubernetes.io/last-applied-configuration"`
		} `json:"annotations"`
		ClusterName string `json:"clusterName"`
	} `json:"metadata"`
	Subsets []struct {
		Addresses []struct {
			IP        string `json:"ip"`
			Hostname  string `json:"hostname"`
			NodeName  string `json:"nodeName"`
			TargetRef struct {
				Kind            string `json:"kind"`
				Namespace       string `json:"namespace"`
				Name            string `json:"name"`
				UID             string `json:"uid"`
				APIVersion      string `json:"apiVersion"`
				ResourceVersion string `json:"resourceVersion"`
				FieldPath       string `json:"fieldPath"`
			} `json:"targetRef"`
		} `json:"addresses"`
		Ports []struct {
			Name     string `json:"name"`
			Port     int    `json:"port"`
			Protocol string `json:"protocol"`
		} `json:"ports"`
	} `json:"subsets"`
}

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		client, err := k8s.NewInClusterClient()
		if err != nil {
			fmt.Fprintf(w, "STEP1: "+string(err.Error()))
		}
		var endpoints corev1.Endpoints
		err = client.Get(context.Background(), "default", "counter", &endpoints)
		if err != nil {
			fmt.Fprintf(w, "STEP2: "+string(err.Error()))
		}
		out, err := json.Marshal(endpoints)
		if err != nil {
			fmt.Fprintf(w, "STEP3: "+string(err.Error()))
		}
		var gen Gen
		json.Unmarshal(out, &gen)
		if err != nil {
			fmt.Fprintf(w, "STEP4: "+string(err.Error()))
		}
		resp, err := http.Get("http://" + gen.Subsets[0].Addresses[0].IP)
		body, err := ioutil.ReadAll(resp.Body)
		if err != nil {
			panic(err)
		}
		fmt.Fprintf(w, string(body))
		return
	})

	http.ListenAndServe(":80", nil)
}
