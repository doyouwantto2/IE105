from pathlib import Path
import json

class Environment:
    def __init__(self):
        self.base_dir = Path(__file__).parent

        self.source_codes_dir = self.base_dir / "source_codes"

        self.data_dir = self.base_dir / "data"

        self.vulnerabilities_dir = self.data_dir / "vulnerabilities"

        self.disputes_dir = self.data_dir / "disputes"

#lấy code cho agent
    def read_source_code(self, relative_path):
        file_path = self.source_codes_dir / relative_path

        with open(file_path, "r", encoding="utf-8") as file:
            return file.read()

#agent phát hiện lỗ hỏng -> gửi thông tin -> environment lưu lại dưới dạng json
    def save_vulnerability(self, vulnerability):
        assertion_id = vulnerability["assertionId"]

        file_path = self.vulnerabilities_dir / f"{assertion_id}.json"

        with open(file_path, "w", encoding="utf-8") as file:
            json.dump(vulnerability, file, indent=4)

if __name__ == "__main__":
    env = Environment()

    code = env.read_source_code(
        "sql_injection/vulnerable_code01.py"
    )

    print(code)

    vulnerability_1 = {
    "assertionId": "assertion_001",
    "source": "sql_injection/vulnerable_code01.py",
    "type": "SQL_INJECTION",
    "line": 8,
    "status": "PROPOSED"
    }

    vulnerability_2 = {
        "assertionId": "assertion_002",
        "source": "sql_injection/vulnerable_code01.py",
        "type": "SQL_INJECTION",
        "line": 8,
        "status": "PROPOSED"
    }

    env.save_vulnerability(vulnerability_1)
    env.save_vulnerability(vulnerability_2)
