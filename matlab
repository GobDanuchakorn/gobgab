% โค้ดเชื่อมต่อ FSL กับ MATLAB (แบบระบุ Path ตรงๆ)
clc;
fprintf('กำลังเชื่อมต่อ FSL กับ MATLAB แบบระบุ Path โดยตรง...\n');

% !!! แก้ไข Path ตรงนี้ให้เป็นที่อยู่ FSL ใน WSL ของคุณ !!!
% รูปแบบ: \\wsl$\<ชื่อ Distribution>\path\to\fsl
fsldir = '\\wsl$\Ubuntu\usr\local\fsl';

% ตรวจสอบว่า Path ที่ระบุมีอยู่จริงหรือไม่
if ~isfolder(fsldir)
    error('❌ ไม่พบโฟลเดอร์ FSL ที่ Path ที่ระบุ\nกรุณาตรวจสอบ Path อีกครั้ง: %s', fsldir);
end

% สร้าง Path ไปยังโฟลเดอร์ยูทิลิตี้
fsl_matlab_path = fullfile(fsldir, 'etc', 'matlab');

% เพิ่ม Path เข้าไปใน MATLAB
addpath(fsl_matlab_path);

fprintf('✅ เชื่อมต่อสำเร็จ! MATLAB รู้จัก Path ของ FSL แล้ว\n');
