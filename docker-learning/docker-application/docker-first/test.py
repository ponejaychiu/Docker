from optparse import OptionParser
from kafka import KafkaConsumer
from kafka import KafkaProducer

parser = OptionParser()
parser.add_option("--action", action="store", choices=["produce", "consume"], type="choice", dest="action")
(options, args) = parser.parse_args()
if options.action == "produce":
    producer = KafkaProducer(bootstrap_servers="localhost:9092")
    for i in range(10):
        producer.send("test", str(i))
        producer.flush()
if options.action == "consume":
    consumer = KafkaConsumer("test", bootstrap_servers=["localhost:9092"], auto_offset_reset='earliest')
    for message in consumer:
        print message
