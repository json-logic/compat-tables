pip uninstall json-logic-qubit panzi-json-logic
pip install json-logic-qubit
export LIBRARY="json-logic-qubit"
python main.py

pip uninstall json-logic-qubit
pip install panzi-json-logic
export LIBRARY="panzi-json-logic"
python main.py
