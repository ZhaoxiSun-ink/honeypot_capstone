import configparser
import subprocess
from scapy.all import sniff, ICMP, TCP,UDP,IP
def filter_icmp_request(pkt,machines):
    ip_list=list(machines.keys())
    #print(pkt.haslayer("IP"),pkt.haslayer('ICMP') and pkt['ICMP'].type == 8, pkt['IP'].dst in ip_list, ip_list)
    if not pkt.haslayer("IP") or  pkt["IP"].dst not in ip_list:
        return False
    if pkt.haslayer('ICMP'):
        return  pkt['IP'].dst in ip_list
    else:
        print(pkt['IP'].dst , ip_list , [pkt[layer].dport for layer in [UDP,TCP] if pkt.haslayer(layer)][0] , machines[pkt["IP"].dst]["port_answer"])
        return pkt['IP'].dst in ip_list and [pkt[layer].dport for layer in [UDP,TCP] if pkt.haslayer(layer)][0] in machines[pkt["IP"].dst]["port_answer"]
def process_packet(pkt,machines):
    if pkt.haslayer("ICMP"):
        filename="python3 icmp.py"
    else:
        print("pas ICMP")
        filename=machines[pkt["IP"].dst]["port_answer"][[pkt[layer].dport for layer in [UDP,TCP] if pkt.haslayer(layer)][0]]
    pkt_hex = pkt.payload.__bytes__().hex()
    print(filename)
    subprocess.run(filename.split(" ")+[pkt_hex])
config = configparser.ConfigParser()
config.read('config.ini')  
nb=0 
machines={}
while config.has_section("machine_"+str(nb)):
    sec="machine_"+str(nb)
    ip=config[sec]['IP']
    machines[ip]={"ip":ip,"port_answer":{int(el.split(",")[0]):el.split(",")[1] for el in config[sec]['port_answer'].split("|")}}
    nb=nb+1
sniff(lfilter=lambda pkt:filter_icmp_request(pkt,machines), prn=lambda pkt:process_packet(pkt,machines), store=0)
