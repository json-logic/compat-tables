pip uninstall json-logic-qubit panzi-json-logic --break-system-packages
pip install json-logic-qubit --break-system-packages
export LIBRARY="json-logic-qubit"
python3 main.py

pip uninstall json-logic-qubit --break-system-packages
pip install panzi-json-logic --break-system-packages
export LIBRARY="panzi-json-logic"
python3 main.py
