import sys
from scapy.all import IP, ICMP, send, Ether

def respond_to_icmp(request_pkt):
    response_pkt = IP(dst=request_pkt[IP].src, src=request_pkt[IP].dst) / ICMP(type="echo-reply", id=request_pkt[ICMP].id, seq=request_pkt[ICMP].seq) / request_pkt[ICMP].payload
    send(response_pkt, verbose=0)
def main(pkt_hex):
    pkt_bytes = bytes.fromhex(pkt_hex)
    request_pkt = IP(pkt_bytes)

    if request_pkt.haslayer(IP):
        respond_to_icmp(request_pkt)
if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: icmp_responder.py pkt_hex")
        sys.exit(1)
    main(sys.argv[1])
