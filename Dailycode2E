class Solution {
public:
    vector<int> searchRange(vector<int>& nums, int target) {
        vector<int> v(2, -1);
        int n = nums.size();
        int left = 0, right = n - 1;

        // First Occurrence
        while(left <= right) {
            int mid = left + (right - left) / 2;

            if(nums[mid] >= target)
                right = mid - 1;
            else
                left = mid + 1;
        }
        if(left < n && nums[left] == target)
            v[0] = left;

        // Last Occurrence
        left = 0, right = n - 1;
        while(left <= right) {
            int mid = left + (right - left) / 2;

            if(nums[mid] <= target)
                left = mid + 1;
            else
                right = mid - 1;
        }
        if(right >= 0 && nums[right] == target)
            v[1] = right;
            
        return v;
    }
};
