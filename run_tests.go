package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"io/ioutil"
	"os"
	"os/exec"
	"path/filepath"
	"time"
)

type GtestTest struct {
	Name      string `json:"name"`
	Status    string `json:"status"`
	Time      string `json:"time"`
	Classname string `json:"classname"`
}

type GtestTestsuite struct {
	Name      string      `json:"name"`
	Tests     int32       `json:"tests"`
	Failures  int32       `json:"failures"`
	Disabled  int32       `json:"disabled"`
	Errors    int32       `json:"errors"`
	Time      string      `json:"time"`
	Testsuite []GtestTest `json:"testsuite"`
}

type GtestResults struct {
	Name      string    `json:"name"`
	Tests     int32     `json:"tests"`
	Failures  int32     `json:"failures"`
	Disabled  int32     `json:"disabled"`
	Errors    int32     `json:"errors"`
	Time      string    `json:"time"`
	TimeStamp time.Time `json:"timestamp"`
}

func loadTestResults(filename string) (*GtestResults, error) {
	contents, err := ioutil.ReadFile(filename)
	if err != nil {
		return nil, err
	}

	var results GtestResults
	err = json.Unmarshal(contents, &results)
	if err != nil {
		return nil, err
	}
	return &results, nil
}

type testRun struct {
	dir   string
	exe   string
	err   error
	state os.ProcessState
}

var verbose bool

func init() {
	flag.BoolVar(&verbose, "verbose", false, "Display test output.")
}

func main() {
	flag.Parse()

	runs := []*testRun{}
	for _, test := range flag.Args() {
		fmt.Printf("Running %s\n", test)
		run := &testRun{
			dir: filepath.Dir(test),
			exe: filepath.Base(test),
		}
		cmd := exec.Command("./"+run.exe, "--gtest_output=json")
		cmd.Dir = run.dir
		out, err := cmd.CombinedOutput()
		run.err = err
		run.state = *cmd.ProcessState
		ioutil.WriteFile(filepath.Join(run.dir, "test_log.txt"), out, 0644)
		if verbose {
			fmt.Print(string(out))
		}
		runs = append(runs, run)
	}

	var totalTests int32
	var totalFailures int32
	var totalDisabled int32
	var totalErrors int32
	for _, run := range runs {
		results, err := loadTestResults(filepath.Join(run.dir, "test_detail.json"))
		if err != nil {
			panic(err.Error())
		}
		totalTests += results.Tests
		totalFailures += results.Failures
		totalDisabled += results.Disabled
		totalErrors += results.Errors
	}

	fmt.Printf("Failures: %d/%d\n", totalFailures, totalTests)
	fmt.Printf("Errors: %d/%d\n", totalErrors, totalTests)
	fmt.Printf("Disabled: %d/%d\n", totalDisabled, totalTests)

	if totalFailures > 0 || totalErrors > 0 {
		os.Exit(1)
	}
}
