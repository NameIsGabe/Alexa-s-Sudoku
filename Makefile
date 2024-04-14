all:
	circom Sudoku.circom --r1cs --wasm --sym --c
	node Sudoku_js/generate_witness.js Sudoku_js/Sudoku.wasm input.json witness.wtns
	snarkjs powersoftau new bn128 12 pot12_0000.ptau -v
	snarkjs powersoftau contribute pot12_0000.ptau pot12_0001.ptau --name="First contribution" -v
	snarkjs powersoftau prepare phase2 pot12_0001.ptau pot12_final.ptau -v
	snarkjs groth16 setup Sudoku.r1cs pot12_final.ptau Sudoku_0000.zkey
	snarkjs zkey contribute Sudoku_0000.zkey Sudoku_0001.zkey --name="1st Contributor Name" -v
	snarkjs zkey export verificationkey Sudoku_0001.zkey verification_key.json
	snarkjs groth16 prove Sudoku_0001.zkey witness.wtns proof.json public.json
	snarkjs groth16 verify verification_key.json public.json proof.json