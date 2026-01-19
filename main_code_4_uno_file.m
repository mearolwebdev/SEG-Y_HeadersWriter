clear; clc; close all;
% Укажите имя входного файла и выходного файла
inputFileName = 'C:\\путь\\имя_исходного_файла.sgy';  % Замените на имя вашего файла
outputFileName = 'C:\\путь\\имя_нового_файла.sgy'; % Имя нового файла

copyfile(inputFileName, outputFileName);
SEG=altreadsegy(inputFileName);
[n,num_tr]=size(SEG);


% Открываем файл в бинарном режиме для чтения
fid = fopen(outputFileName, 'r+b', 'l');

if fid == -1
    error('Не удалось открыть файл: %s', inputFileName);
end


for i = 1:num_tr
    L=1;
    dx = 100/(num_tr-1);
    cdp_x = (i-1) * dx + 1000;
    sou_x = cdp_x + L./2;
    grp_x = cdp_x - L./2;

    cdp_y = 1000;
    sou_y = 1000;
    grp_y = 1000;

    position_cdp_x = 3200 + 400 + (i-1)*(240 + 2*n) + 181 -1;
    fseek(fid, position_cdp_x, 'bof'); % bof - запись с начала файла   
    fwrite(fid, uint64(cdp_x.*1000), 'uint64');

    position_cdp_y = position_cdp_x + 4;
    fseek(fid, position_cdp_y, 'bof'); % bof - запись с начала файла   
    fwrite(fid, uint64(cdp_y.*1000), 'uint64');

    position_sou_x = 3200 + 400 + (i-1)*(240 + 2*n) + 73 -1;
    fseek(fid, position_sou_x, 'bof'); % bof - запись с начала файла   
    fwrite(fid, uint64(sou_x.*1000), 'uint64');

    position_sou_y = position_sou_x + 4;
    fseek(fid, position_sou_y, 'bof'); % bof - запись с начала файла   
    fwrite(fid, uint64(sou_y.*1000), 'uint64');

    position_grp_x = 3200 + 400 + (i-1)*(240 + 2*n) + 81 -1;
    fseek(fid, position_grp_x, 'bof'); % bof - запись с начала файла   
    fwrite(fid, uint64(grp_x.*1000), 'uint64');

    position_grp_y = position_grp_x + 4;
    fseek(fid, position_grp_y, 'bof'); % bof - запись с начала файла   
    fwrite(fid, uint64(grp_y.*1000), 'uint64');
end

% Закрываем файл
fclose(fid);

disp('Файл успешно изменен и сохранен как новый.');