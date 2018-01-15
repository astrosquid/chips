class Ground():
	def __init__(self):
		self.output = 0

class Vcc():
	def __init__(self):
		self.output = 1

class LogicChip():
	def __init__(self, inputs):
		x = []
		for i in inputs:
			x.append(i.output)
		self.inputs = x
		self.output = None

	def new_inputs(self, inputs):
		x = []
		for i in inputs:
			x.append(i.output)
		self.inputs = x

class And(LogicChip):
	def __init__(self, inputs):
		super().__init__(inputs)
		self.input_values = set()
		for i in inputs:
			self.input_values.add(i.output)

	def do(self):
		if len(set(self.inputs)) == 1:
			self.output = 1
		else: 
			self.output = 0

class Or(LogicChip):
	def __init__(self, inputs):
		super().__init__(inputs)
		
	def do(self):
		for i in self.inputs:
			if i == 1:
				self.output = 1
			
		if self.output != 1:
			self.output = 0

class Xor(LogicChip):
	def __init__(self, inputs):
		super().__init__(inputs)

	def do(self):
		flag = False
		for i in self.inputs:
			if i == 1 and flag == True:
				self.output = 0
				flag = False
				break
			elif i == 1 and flag == False:
				flag = True

		if flag == True:
			self.output = 1

class Nand(LogicChip):
	def __init__(self, inputs):
		super().__init__(inputs)

	def do(self):
		if len(set(self.inputs)) == 1:
			self.output = 0
		else:
			self.output = 1

def test_it():
	vcc = Vcc()
	ground = Ground()
	nand = Nand([vcc, ground])
	nand.do()
	print(nand.output)

if __name__ == "__main__":
	test_it()