Ta chia Agent thành các nhóm để cùng nhau tìm lỗ hổng trong source code của các phần mềm. Nếu phát hiện một lỗ hổng bất kỳ thì nó sẽ tạo một báo cáo và ghi nhận lên blockchain tương tự như cách optimistic roll-ups hoạt động.

Dữ liệu về lỗ hổng có trạng thái VALID sẽ được đưa vào flower để training các model. Các Agent khác cũng sẽ cập nhật thông tin dựa trên nó.

Các nhóm Agent khác bên cạnh truy tìm lỗ hổng để nhận được điểm thì cũng sẽ kiểm tra báo cáo lỗ hổng mà các nhóm Agent khác lập ra để kiểm chứng xem liệu lỗ hổng đó có thật hay không. Nếu một nhóm phát hiện một lỗ hổng được báo cáo sai thì sẽ kích hoạt cơ chế tranh chấp để phân xử, các nhóm Agent khác sẽ đứng ra kiểm chứng và bỏ phiếu bên nào chiến thắng.

Nếu bên tố cáo thắng thì sẽ được nhận điểm thưởng, đồng thời trạng thái của dữ liệu về lỗ hổng được ghi nhận trên blockchain sẽ chuyển từ VALID sang INVALID. Còn trong trường hợp các nhóm Agent khác xử bên tố cáo thua thì bên tố cáo sẽ bị mất điểm.

Cân bằng Nash muốn đạt được đó là các Agent xác định lỗi chính xác hơn và chỉ mở tranh chấp nếu có căn cứ rõ ràng về việc một lỗi bị báo sai.
