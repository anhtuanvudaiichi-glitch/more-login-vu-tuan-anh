# 10-CUTOVER-ROLLBACK-OPERATIONS

## 1) Mục tiêu

- Chuyển đổi hệ thống an toàn từ môi trường chuẩn bị sang production.
- Có khả năng rollback nhanh khi gặp lỗi nghiêm trọng.
- Giảm downtime và rủi ro dữ liệu.

## 2) Điều kiện trước cutover

- [ ] UAT đã sign-off.
- [ ] Contract test agent pass.
- [ ] Backup dữ liệu đầy đủ và verify restore pass.
- [ ] On-call roster đã chốt.
- [ ] Feature flags cho rollback đã sẵn sàng.

## 3) Runbook cutover

### Bước 1: Freeze thay đổi

- Đóng merge code ngoài phạm vi go-live.
- Chốt tag release và build artifact.

### Bước 2: Pre-flight checks

- Kiểm tra env vars Replit.
- Kiểm tra kết nối DB/Redis/Agent.
- Kiểm tra health endpoints web tools + agent.

### Bước 3: Enable production traffic

- Mở traffic theo tỷ lệ (canary nếu có).
- Theo dõi error rate, latency, queue backlog trong 30-60 phút đầu.

### Bước 4: Verify nghiệp vụ cốt lõi

- Luồng account/profile.
- Luồng callback/inbox.
- Luồng campaign async + polling.
- Luồng reports và audit.

### Bước 5: Chốt cutover

- Ghi biên bản cutover thành công.
- Chuyển trạng thái phát hành sang stable.

## 4) Rollback strategy

### 4.1 Điều kiện trigger rollback

- Có lỗi Sev-1 ảnh hưởng diện rộng.
- Tỷ lệ lỗi agent call vượt ngưỡng an toàn liên tục.
- Lỗi dữ liệu nghiêm trọng không khắc phục nhanh.

### 4.2 Cách rollback

1. Bật feature flag khóa luồng rủi ro cao (campaign/async).
2. Chuyển traffic về phiên bản trước ổn định.
3. Tạm dừng worker nếu gây lỗi lan rộng.
4. Khôi phục dữ liệu từ backup nếu cần.
5. Xác nhận health và nghiệp vụ tối thiểu trước mở lại traffic.

### 4.3 Mục tiêu thời gian

- MTTR mục tiêu Sev-1: <= 60 phút.
- MTTR mục tiêu Sev-2: <= 120 phút.

## 5) Quy trình xử lý sự cố

| Mức độ | Điều kiện | Người chịu trách nhiệm |
|---|---|---|
| Sev-1 | Mất dịch vụ lõi diện rộng | Incident Commander + Tech Lead |
| Sev-2 | Lỗi nặng một phần chức năng | Tech Lead + DevOps |
| Sev-3 | Lỗi cục bộ workaround được | Module owner |

## 6) Checklist sau cutover

- [ ] Không có incident mở Sev-1/Sev-2.
- [ ] KPI ổn định theo ngưỡng mục tiêu.
- [ ] Audit log đầy đủ cho giai đoạn cutover.
- [ ] Postmortem nếu có sự cố.

## 7) Postmortem template tối thiểu

- Timeline sự cố.
- Root cause.
- Ảnh hưởng và phạm vi.
- Biện pháp khắc phục tức thời.
- Hành động phòng ngừa lặp lại.

## 8) Cập nhật tài liệu sau go-live

Sau mỗi thay đổi lớn/cutover:
- Cập nhật `03` (roadmap/WBS) nếu thay đổi lộ trình.
- Cập nhật `06` nếu có thay đổi contract/mapping.
- Cập nhật `09` nếu có bài học test mới.
- Cập nhật `10` nếu có cải tiến runbook/rollback.
