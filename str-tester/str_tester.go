package main

import (
	"bytes"
	"fmt"
	"strconv"
	"time"
)

var cycles = 1000000000

func main() {
	var o_start,o_end time.Time
	var n_start,n_end time.Time
	var session_id int64
	var proto_name string
	var data_len int
	var command string
	
	session_id = 123456789
	proto_name = "IP4"
	data_len = 1432

	o_start = time.Now()
	for x := 0; x < cycles; x++ {
		command = fmt.Sprintf("PACKET|%d|%s|%d\r\n", session_id, proto_name,data_len)
	}
	o_end = time.Now()
	odiff := o_end.Sub(o_start)
	fmt.Printf("SPRINTF = %v %s\n", odiff, command)

	n_start = time.Now()
	for x := 0; x < cycles; x++ {
		command = formPacketCommand(session_id, proto_name,data_len)
	}
	n_end = time.Now()
	ndiff := n_end.Sub(n_start)
	fmt.Printf("STRCONV = %v %s\n", ndiff, command)
}

func formPacketCommand(session int64, protocol string, length int) string {
	var pktCmd bytes.Buffer
	pktCmd.WriteString("PACKET|")
	pktCmd.WriteString(strconv.FormatInt(session, 10))
	pktCmd.WriteString("|")
	pktCmd.WriteString(protocol)
	pktCmd.WriteString("|")
	pktCmd.WriteString(strconv.Itoa(length))
	pktCmd.WriteString("\r\n")
	return pktCmd.String()
}
