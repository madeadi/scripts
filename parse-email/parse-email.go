package main

import (
	// "bufio"
	"fmt"
	// "io"
	"io/ioutil"
	"os"
	// "regexp"
	"strings"
	"path/filepath"
)

func check(e error) {
	if e != nil {
		panic(e);
	}
}

func readEmail(file string) []string {
	temp := strings.Split(file, "\n")
	var emails []string

	for _, item := range temp {
		if(strings.Contains(item, "@") && !strings.Contains(item, " ")){
			emails = append(emails, item)
		}
	}

	return emails
}


func main() {
	// reader := bufio.NewReader(os.Stdin)
  // fmt.Println("Extract Email from text")
	// fmt.Println("---------------------")
	
	// for {
    // fmt.Print("Enter folder path ->: ")
		// userpath, _ := reader.ReadString('\n')
		// fmt.Println(userpath)
		
		userpath := "/Users/madeadi/Downloads/textract"
		err := filepath.Walk(userpath, 
			func(path string, info os.FileInfo, err error) error {
				if err != nil {
					return err
				}
				if strings.Contains(path, ".txt") {
					dat, err := ioutil.ReadFile(path)
					check(err)
	
					file := string(dat)
					
					emails := readEmail(file)
					for _, email := range emails {
						fmt.Println(email)
					}
				}
				
				return nil 
		})
		check(err)
  // }

}