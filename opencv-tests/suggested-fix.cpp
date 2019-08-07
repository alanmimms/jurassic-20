    int morph_elem = 1;
    int morph_size = 1;
    int morph_operator = 0;

    Mat origImage = mat;
    medianBlur(origImage, origImage,1);
    cvtColor(origImage, origImage, COLOR_RGB2GRAY);
    threshold(origImage, origImage, 0, 255, THRESH_OTSU);

    Mat element = getStructuringElement(morph_elem, Size(2 * morph_size + 1, 2 * morph_size + 1), cv::Point(morph_size, morph_size));

    morphologyEx(origImage, origImage, MORPH_OPEN, element);
    //thin(origImage, true, true, true);
    imshow("@", origImage);
