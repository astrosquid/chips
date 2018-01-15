class Ground():
	def __init__(self):
		self.output = [0]

class Vcc():
	def __init__(self):
		self.output = [1]

class LogicChip():
	def __init__(self, enter=[0], output=0):
		self.enter = enter
		self.output = output

class And(LogicChip):
	def __init__(self, enter, output):
		super().__init__(enter, output)

	def do(self):
		if self.enter[0] == 1 and self.enter[1] == 1:
			self.output = 1
		else:
			self.output = 0

class Or(LogicChip):
	def __init__(self, enter, output):
		super().__init__(enter, output)

	def do(self):
		if self.enter[0] == 1 or self.enter[1] == 1:
			self.output = 1
		else:
			self.output = 0

class Xor(LogicChip):
	def __init__(self, enter, output):
		super().__init__(enter, output)

	def do(self):
		if self.enter[0] == 1 and self.enter[1] == 0:
			self.output = 1
		elif self.enter[0] == 0 and self.enter[1] == 1:
			self.output = 1
		else:
			self.output = 0

class Nand(LogicChip):
	def __init__(self, enter, output):
		super().__init__(enter, output)

	def do(self):
		if self.enter[0] == 1 and self.enter[1] == 1:
			self.output = 0
		else:
			self.output = 1

def test_it():
	vcc = Vcc()
	ground = Ground()
	nand = Nand([vcc.output, ground.output], None)
	nand.do()
	print(nand.output)

if __name__ == "__main__":
	test_it()