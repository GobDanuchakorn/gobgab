fsldir = getenv('FSLDIR');
fslmatlab = sprintf('%s/etc/matlab', fsldir);
addpath(fslmatlab);

edit(fullfile(userpath,'startup.m'))

% โค้ดสำหรับเชื่อมต่อ FSL กับ MATLAB
clc;
fprintf('กำลังเชื่อมต่อ FSL กับ MATLAB...\n');

% 1. ดึงที่อยู่ของ FSL จาก Environment Variable ของระบบ ('FSLDIR')
fsldir = getenv('FSLDIR');

% 2. ตรวจสอบว่าหา FSLDIR เจอหรือไม่
if isempty(fsldir)
    error('❌ ไม่พบ Environment Variable "FSLDIR" ของ FSL\nกรุณาตรวจสอบว่าคุณติดตั้ง FSL และตั้งค่า Shell ถูกต้องแล้ว');
end

% 3. สร้าง Path เต็มไปยังโฟลเดอร์ยูทิลิตี้ของ MATLAB ภายใน FSL
%    ใช้ fullfile เพื่อความเข้ากันได้กับทุกระบบปฏิบัติการ
fsl_matlab_path = fullfile(fsldir, 'etc', 'matlab');

% 4. เพิ่ม Path ที่สร้างขึ้นเข้าไปในรายการ Path ของ MATLAB
addpath(fsl_matlab_path);

fprintf('✅ เชื่อมต่อสำเร็จ! MATLAB รู้จัก Path ของ FSL แล้ว\n');
fprintf('   ที่อยู่: %s\n', fsl_matlab_path);
