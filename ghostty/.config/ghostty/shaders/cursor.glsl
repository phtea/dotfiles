const float CURSOR_ALPHA = 0.1;
const float CURSOR_THICKNESS = 0.0005;
const vec3 CURSOR_COLOR = vec3(0.662);

const float TRAIL_DURATION = 0.015;
const float TRAIL_ALPHA = 0.005;
const float TRAIL_THICKNESS = 0.01;
const vec3 TRAIL_COLOR = vec3(0.5);

float getSdfRectangle(in vec2 p, in vec2 xy, in vec2 b) {
    vec2 d = abs(p - xy) - b;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

float sdSegment(in vec2 p, in vec2 a, in vec2 b) {
    vec2 pa = p - a;
    vec2 ba = b - a;
    float h = clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0);
    return length(pa - ba * h);
}

vec2 norm(vec2 value, float isPosition) {
    return (value * 2.0 - (iResolution.xy * isPosition)) / iResolution.y;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    // Get background texture
    fragColor = texture(iChannel0, fragCoord.xy / iResolution.xy);
    vec2 vu = norm(fragCoord, 1.);
    
    // Normalize cursor position and size
    vec4 currentCursor = vec4(norm(iCurrentCursor.xy, 1.), norm(iCurrentCursor.zw, 0.));
    vec4 previousCursor = vec4(norm(iPreviousCursor.xy, 1.), norm(iPreviousCursor.zw, 0.));
    
    // Calculate cursor SDF
    vec2 offsetFactor = vec2(-0.5, 0.5);
    float sdfCurrentCursor = getSdfRectangle(
        vu, 
        currentCursor.xy - (currentCursor.zw * offsetFactor), 
        currentCursor.zw * 0.5
    );
    
    // Apply cursor with transparency
    float cursorMask = step(sdfCurrentCursor, CURSOR_THICKNESS);
    fragColor.rgb = mix(fragColor.rgb, CURSOR_COLOR, cursorMask * CURSOR_ALPHA);
    
    // Calculate trail progress
    float progress = clamp((iTime - iTimeCursorChange) / TRAIL_DURATION, 0.0, 1.0);
    float easedProgress = 1.0 - progress * progress;
    
    // Only draw trail if there's movement
    if (distance(currentCursor.xy, previousCursor.xy) > 0.002) {
        // Calculate center points for trail
        vec2 centerCurrent = vec2(
            currentCursor.x + currentCursor.z / 2.0, 
            currentCursor.y - currentCursor.w / 2.0
        );
        vec2 centerPrevious = vec2(
            previousCursor.x + previousCursor.z / 2.0, 
            previousCursor.y - previousCursor.w / 2.0
        );
        
        // Proper trail calculation using segment distance
        float trailDistance = sdSegment(vu, centerPrevious, centerCurrent);
        float trailMask = step(trailDistance, TRAIL_THICKNESS * easedProgress);
        
        // Apply trail with transparency
        fragColor.rgb = mix(fragColor.rgb, TRAIL_COLOR, trailMask * TRAIL_ALPHA * easedProgress);
    }
}
