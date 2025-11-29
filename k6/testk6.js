import http from "k6/http";
import { check, sleep } from "k6";

export let options = {
    stages: [
        { duration: "1m", target: 200 },
        { duration: "3m", target: 500 },
        { duration: "1m", target: 0 },
    ],
    thresholds: {
        http_req_duration: ["p(95)<1000"],
        http_req_failed: ["rate<0.02"],
        checks: ["rate>0.99"],
    },
};

export default function () {
    const url = __ENV.ALB_URL;

    const res = http.get(url);

    check(res, {
        "status 200": (r) => r.status === 200,
    });

    sleep(1);
}