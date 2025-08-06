edit(fullfile(userpath,'startup.m'))



fsldir = '\\wsl$\Ubuntu\home\davgob\fsl';

if isfolder(fsldir)
    fsl_matlab_path = fullfile(fsldir, 'etc', 'matlab');
    addpath(fsl_matlab_path);
    fprintf('FSL Path added automatically from startup.m\n');
end


clear;
clc;
close all;

fprintf('เริ่มต้นสคริปต์...\n');
fprintf('กรุณาเลือกไฟล์ภาพสมองที่ผ่านการตัดกะโหลกแล้ว (.nii หรือ .nii.gz)\n');

[filename, pathname] = uigetfile({'*.nii';'*.nii.gz'}, 'เลือกไฟล์ภาพสมอง (Skull-Stripped)');

if isequal(filename, 0)
    fprintf('ยกเลิกการทำงาน\n');
    return;
end

full_file_path = fullfile(pathname, filename);
fprintf('คุณได้เลือกไฟล์: %s\n\n', full_file_path);

try
    fprintf('กำลังโหลดข้อมูลภาพ...\n');
    [img, dims] = read_avw(full_file_path);
    fprintf('โหลดข้อมูลสำเร็จ! ขนาดภาพ: %d x %d x %d\n\n', dims(1), dims(2), dims(3));

    fprintf('กำลังแสดงผลภาพ...\n');
    figure('Name', ['MRI Viewer: ' filename], 'NumberTitle', 'off', 'Color', 'w');

    axial_slice = rot90(img(:, :, round(dims(3)/2)));
    subplot(1, 3, 1);
    imagesc(axial_slice);
    title('Axial View');
    colormap('gray'); axis image; axis off;

    coronal_slice = rot90(squeeze(img(:, round(dims(2)/2), :)));
    subplot(1, 3, 2);
    imagesc(coronal_slice);
    title('Coronal View');
    colormap('gray'); axis image; axis off;

    sagittal_slice = rot90(squeeze(img(round(dims(1)/2), :, :)));
    subplot(1, 3, 3);
    imagesc(sagittal_slice);
    title('Sagittal View');
    colormap('gray'); axis image; axis off;

    fprintf('แสดงผลภาพเรียบร้อย!\n');

catch ME
    if strcmp(ME.identifier, 'MATLAB:UndefinedFunction') && contains(ME.message, 'read_avw')
        fprintf('\n❌ เกิดข้อผิดพลาด: ไม่พบฟังก์ชัน "read_avw"\n');
        fprintf('กรุณาตรวจสอบว่าคุณได้เชื่อมต่อ MATLAB กับ FSL อย่างถูกต้องแล้ว\n');
    else
        rethrow(ME);
    end
end
