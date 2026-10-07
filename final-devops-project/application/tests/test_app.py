import json
import unittest

from app import app


class AppTestCase(unittest.TestCase):
    def setUp(self):
        self.client = app.test_client()

    def test_index_returns_hello_message(self):
        response = self.client.get("/")
        self.assertEqual(response.status_code, 200)
        self.assertTrue(response.is_json)
        self.assertEqual(
            json.loads(response.data), {"message": "Hello World from DevOps"}
        )

    def test_health_returns_ok(self):
        response = self.client.get("/health")
        self.assertEqual(response.status_code, 200)
        self.assertTrue(response.is_json)
        self.assertEqual(json.loads(response.data), {"status": "ok"})

    def test_metrics_returns_prometheus_text(self):
        response = self.client.get("/metrics")
        self.assertEqual(response.status_code, 200)
        self.assertIn("text/plain", response.content_type)
        self.assertIn("demo_requests_total", response.get_data(as_text=True))


if __name__ == "__main__":
    unittest.main()
